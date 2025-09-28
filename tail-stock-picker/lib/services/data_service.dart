import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_model.dart';
import '../utils/constants.dart';
import '../utils/time_utils.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // 腾讯财经API基础URL
  final String _baseUrl = 'http://qt.gtimg.cn/q=';
  
  // 获取股票实时数据
  Future<Stock?> getStockRealTimeData(String stockCode) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$stockCode'));
      
      if (response.statusCode == 200) {
        return _parseTencentData(response.body, stockCode);
      } else {
        throw Exception('获取数据失败: ${response.statusCode}');
      }
    } catch (e) {
      print('获取股票数据错误: $e');
      return null;
    }
  }

  // 解析腾讯财经数据格式
  Stock _parseTencentData(String data, String stockCode) {
    // 腾讯数据格式: v_sz000858="51~五粮液~000858~145.50~+4.20~+2.97~145.50~142.00~..."
    final matches = RegExp(r'="([^"]+)"').firstMatch(data);
    if (matches == null) throw Exception('数据格式错误');
    
    final values = matches.group(1)!.split('~');
    
    // 注意：腾讯接口字段位置可能会变动，这里根据最新格式调整
    return Stock(
      code: stockCode,
      name: values[1],
      currentPrice: double.tryParse(values[3]) ?? 0,
      changePercent: double.tryParse(values[4] ?? '0') ?? 0,
      volumeRatio: double.tryParse(values[49] ?? '0') ?? 0, // 量比在特定位置
      turnoverRate: double.tryParse(values[38] ?? '0') ?? 0, // 换手率
      marketCap: double.tryParse(values[44] ?? '0') ?? 0, // 流通市值
      highPrice: double.tryParse(values[33] ?? '0') ?? 0,
      lowPrice: double.tryParse(values[34] ?? '0') ?? 0,
      openPrice: double.tryParse(values[32] ?? '0') ?? 0,
      closePrice: double.tryParse(values[4] ?? '0') ?? 0, // 注意：这里实际是涨跌额，需要计算昨日收盘价
      volume: double.tryParse(values[36] ?? '0') ?? 0,
      amount: double.tryParse(values[37] ?? '0') ?? 0,
      isMultiLineArrangement: false, // 需要额外计算
      isNewHigh: _checkIsNewHigh(values), // 检查是否新高
      relativeStrength: 0, // 需要额外计算
      updateTime: DateTime.now(),
    );
  }

  bool _checkIsNewHigh(List<String> values) {
    final currentPrice = double.tryParse(values[3]) ?? 0;
    final highPrice = double.tryParse(values[33]) ?? 0;
    return currentPrice >= highPrice;
  }

  // 批量获取股票数据
  Future<List<Stock>> getMultipleStocks(List<String> stockCodes) async {
    final List<Stock> stocks = [];
    
    for (final code in stockCodes) {
      final stock = await getStockRealTimeData(code);
      if (stock != null) {
        stocks.add(stock);
      }
      // 添加延迟避免请求过快
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    return stocks;
  }

  // 获取热门股票列表（用于测试）
  List<String> getDefaultStockList() {
    return [
      'sz000858', // 五粮液
      'sh600036', // 招商银行
      'sz000001', // 平安银行
      'sh601318', // 中国平安
      'sz000002', // 万科A
      'sh600519', // 贵州茅台
      'sz000651', // 格力电器
      'sh600887', // 伊利股份
      'sz000333', // 美的集团
      'sh601166', // 兴业银行
    ];
  }
}
// 在 DataService 类中添加这个方法
Map<String, dynamic> getServiceStatus() {
  return {
    'lastUpdate': DateTime.now(),
    'totalRequests': _requestCount,
    'errorCount': _errorCount,
    'status': _errorCount > 10 ? 'degraded' : 'normal'
  };
}

// 添加统计变量
int _requestCount = 0;
int _errorCount = 0;

// 修改 getStockRealTimeData 方法，在 try-catch 中增加统计
Future<Stock?> getStockRealTimeData(String stockCode) async {
  _requestCount++;
  try {
    // 原有代码不变...
  } catch (e) {
    _errorCount++;
    print('获取股票数据错误: $e');
    return null;
  }
}