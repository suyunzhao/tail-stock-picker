import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/stock_model.dart';
import 'services/data_service.dart';
import 'services/analysis_service.dart';
import 'services/notification_service.dart';
import 'widgets/stock_card.dart';
import 'widgets/loading_widget.dart';
import 'utils/constants.dart';
import 'utils/time_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化通知服务
  await NotificationService().init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DataService>(create: (_) => DataService()),
        Provider<AnalysisService>(create: (_) => AnalysisService()),
        Provider<NotificationService>(create: (_) => NotificationService()),
      ],
      child: MaterialApp(
        title: '尾盘选股助手',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'SFPro',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StockAnalysisScreen(),
      ),
    );
  }
}

class StockAnalysisScreen extends StatefulWidget {
  @override
  _StockAnalysisScreenState createState() => _StockAnalysisScreenState();
}

class _StockAnalysisScreenState extends State<StockAnalysisScreen> {
  final List<AnalysisResult> _analysisResults = [];
  bool _isLoading = false;
  String _statusMessage = '准备分析尾盘股票...';
  DateTime? _lastAnalysisTime;

  @override
  void initState() {
    super.initState();
    _checkAutoAnalysis();
  }

  void _checkAutoAnalysis() {
    if (TimeUtils.isTailAnalysisTime()) {
      _runAnalysis();
    }
  }

  Future<void> _runAnalysis() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '🔄 获取实时股票数据中...';
    });

    try {
      final dataService = Provider.of<DataService>(context, listen: false);
      final analysisService = Provider.of<AnalysisService>(context, listen: false);
      final notificationService = Provider.of<NotificationService>(context, listen: false);

      // 获取股票数据
      final stockCodes = dataService.getDefaultStockList();
      final stocks = await dataService.getMultipleStocks(stockCodes);

      setState(() {
        _statusMessage = '📊 分析股票技术指标...';
      });

      // 分析股票
      final allResults = analysisService.analyzeStocks(stocks);
      final qualifiedResults = analysisService.filterQualifiedStocks(allResults);

      setState(() {
        _analysisResults.clear();
        _analysisResults.addAll(qualifiedResults);
        _isLoading = false;
        _lastAnalysisTime = DateTime.now();
        _statusMessage = '✅ 分析完成！找到 ${qualifiedResults.length} 只符合条件的股票';
      });

      // 发送通知
      if (qualifiedResults.isNotEmpty) {
        notificationService.showAnalysisCompleteNotification(qualifiedResults.length);
      }

    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ 分析失败: $e';
      });
    }
  }

  String _getLastAnalysisText() {
    if (_lastAnalysisTime == null) return '尚未分析';
    
    final now = DateTime.now();
    final difference = now.difference(_lastAnalysisTime!);
    
    if (difference.inMinutes < 1) return '刚刚更新';
    if (difference.inMinutes < 60) return '${difference.inMinutes}分钟前';
    return '${difference.inHours}小时前';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('尾盘选股助手'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 设置页面将在后续添加
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _runAnalysis,
          ),
        ],
      ),
      body: Column(
        children: [
          // 状态栏
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _isLoading ? Colors.blue : Colors.green[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '最后更新: ${_getLastAnalysisText()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // 分析结果列表
          Expanded(
            child: _isLoading 
                ? LoadingWidget(message: _statusMessage)
                : _analysisResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              '暂无符合条件的股票',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '请点击下方按钮开始分析',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemCount: _analysisResults.length,
                        itemBuilder: (context, index) {
                          return StockCard(result: _analysisResults[index]);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _runAnalysis,
        child: Icon(Icons.play_arrow),
        tooltip: '开始尾盘分析',
        backgroundColor: _isLoading ? Colors.grey : Colors.blue,
      ),
    );
  }
}