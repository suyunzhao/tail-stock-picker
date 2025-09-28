import '../models/stock_model.dart';
import '../models/analysis_result.dart';
import '../utils/constants.dart';

class AnalysisService {
  // 基础条件筛选
  bool checkBasicConditions(Stock stock) {
    return stock.changePercent >= AppConstants.minGain &&
           stock.changePercent <= AppConstants.maxGain &&
           stock.volumeRatio > AppConstants.minVolumeRatio &&
           stock.turnoverRate >= AppConstants.minTurnoverRate &&
           stock.turnoverRate <= AppConstants.maxTurnoverRate &&
           stock.marketCap >= AppConstants.minMarketCap &&
           stock.marketCap <= AppConstants.maxMarketCap;
  }

  // 技术分析评分 (0-60分)
  double calculateTechnicalScore(Stock stock) {
    double score = 0.0;
    
    // 均线多头排列 (30分)
    if (_checkMultiLineArrangement(stock)) {
      score += 30;
    }
    
    // 成交量趋势 (20分)
    if (_checkVolumeTrend(stock)) {
      score += 20;
    }
    
    // 相对强度 (10分)
    score += _calculateRelativeStrengthScore(stock);
    
    return score;
  }

  // 检查均线多头排列（简化版）
  bool _checkMultiLineArrangement(Stock stock) {
    // 这里需要历史数据，暂时返回随机结果用于测试
    // 实际实现需要获取5日、10日、20日、60日均线数据
    return stock.changePercent > 0; // 简化逻辑
  }

  // 检查成交量趋势
  bool _checkVolumeTrend(Stock stock) {
    return stock.volumeRatio > 1.5; // 量比大于1.5认为放量
  }

  // 计算相对强度评分
  double _calculateRelativeStrengthScore(Stock stock) {
    // 简化逻辑：涨幅大于3%得满分
    return stock.changePercent > 3.0 ? 10.0 : stock.changePercent / 0.3;
  }

  // 综合评分 (基础40分 + 技术60分)
  double calculateTotalScore(Stock stock) {
    final double baseScore = checkBasicConditions(stock) ? 40.0 : 0.0;
    final double technicalScore = calculateTechnicalScore(stock);
    return baseScore + technicalScore;
  }

  // 生成推荐等级
  String getRecommendationLevel(double score) {
    if (score >= 85) return 'strong';
    if (score >= 70) return 'recommended';
    if (score >= 60) return 'cautious';
    return 'not_recommended';
  }

  // 计算止损价格
  double calculateStopLossPrice(Stock stock) {
    return stock.currentPrice * 0.95; // 5%止损
  }

  // 计算建议仓位
  double calculateSuggestedPosition(double score) {
    if (score >= 90) return 0.25;
    if (score >= 80) return 0.20;
    if (score >= 70) return 0.15;
    if (score >= 60) return 0.10;
    return 0.0;
  }

  // 执行完整分析
  AnalysisResult analyzeStock(Stock stock) {
    final double totalScore = calculateTotalScore(stock);
    
    return AnalysisResult(
      stock: stock,
      score: totalScore,
      recommendation: getRecommendationLevel(totalScore),
      stopLossPrice: calculateStopLossPrice(stock),
      suggestedPosition: calculateSuggestedPosition(totalScore),
      analysisDetails: {
        'baseConditionsMet': checkBasicConditions(stock),
        'technicalScore': calculateTechnicalScore(stock),
        'volumeTrend': _checkVolumeTrend(stock),
        'multiLineArrangement': _checkMultiLineArrangement(stock),
      },
    );
  }

  // 批量分析股票
  List<AnalysisResult> analyzeStocks(List<Stock> stocks) {
    return stocks.map((stock) => analyzeStock(stock)).toList()
      ..sort((a, b) => b.score.compareTo(a.score)); // 按评分降序排列
  }

  // 筛选符合条件的股票
  List<AnalysisResult> filterQualifiedStocks(List<AnalysisResult> results) {
    return results.where((result) => result.score >= 60).toList();
  }
}
// 在 AnalysisService 类中添加这个方法
String getAnalysisSummary(List<AnalysisResult> results) {
  final strongCount = results.where((r) => r.recommendation == 'strong').length;
  final recommendedCount = results.where((r) => r.recommendation == 'recommended').length;
  
  if (results.isEmpty) {
    return '暂无符合条件股票';
  } else if (strongCount > 0) {
    return '发现$strongCount只强烈推荐股票';
  } else if (recommendedCount > 0) {
    return '发现$recommendedCount只推荐股票';
  } else {
    return '发现${results.length}只谨慎关注股票';
  }
}
