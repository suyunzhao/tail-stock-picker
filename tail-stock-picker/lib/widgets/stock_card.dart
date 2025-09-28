import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class StockCard extends StatelessWidget {
  final AnalysisResult result;
  final VoidCallback? onTap;
  
  const StockCard({Key? key, required this.result, this.onTap}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 股票标题和评分
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.stock.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          result.stock.code,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildScoreBadge(result.score),
                ],
              ),
              
              SizedBox(height: 12),
              
              // 价格和涨跌幅
              Row(
                children: [
                  Text(
                    '¥${result.stock.currentPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getPriceColor(result.stock.changePercent),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getPriceColor(result.stock.changePercent).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${result.stock.changePercent > 0 ? '+' : ''}${result.stock.changePercent.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: _getPriceColor(result.stock.changePercent),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // 技术指标标签
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildIndicatorChip('量比: ${result.stock.volumeRatio.toStringAsFixed(1)}'),
                  _buildIndicatorChip('换手: ${result.stock.turnoverRate.toStringAsFixed(1)}%'),
                  _buildIndicatorChip('市值: ${result.stock.marketCap.toStringAsFixed(0)}亿'),
                  if (result.analysisDetails['multiLineArrangement'] == true)
                    _buildIndicatorChip('多头排列', isPositive: true),
                  if (result.analysisDetails['volumeTrend'] == true)
                    _buildIndicatorChip('放量', isPositive: true),
                  if (result.stock.isNewHigh)
                    _buildIndicatorChip('新高', isPositive: true),
                ],
              ),
              
              SizedBox(height: 12),
              
              // 推荐信息和风控
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${result.recommendationText}',
                          style: TextStyle(
                            color: Color(result.recommendationColor),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '仓位 ${(result.suggestedPosition * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '止损: ¥${result.stopLossPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${((1 - result.stopLossPrice / result.stock.currentPrice) * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildScoreBadge(double score) {
    Color color;
    String label;
    
    if (score >= 85) {
      color = Color(0xFF4CAF50);
      label = '优秀';
    } else if (score >= 70) {
      color = Color(0xFF2196F3);
      label = '良好';
    } else if (score >= 60) {
      color = Color(0xFFFF9800);
      label = '一般';
    } else {
      color = Colors.grey;
      label = '较差';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${score.toInt()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIndicatorChip(String text, {bool isPositive = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isPositive ? Colors.green[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isPositive ? Colors.green[100]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: isPositive ? Colors.green[700] : Colors.grey[700],
          fontWeight: isPositive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
  
  Color _getPriceColor(double changePercent) {
    if (changePercent > 0) return Color(0xFFE53935);
    if (changePercent < 0) return Color(0xFF4CAF50);
    return Colors.grey;
  }
}