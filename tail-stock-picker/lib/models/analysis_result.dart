class AnalysisResult {
  final Stock stock;
  final double score;           // 综合评分 (0-100)
  final String recommendation;  // 推荐等级
  final double stopLossPrice;   // 止损价
  final double suggestedPosition; // 建议仓位百分比
  final Map<String, dynamic> analysisDetails; // 详细分析数据

  AnalysisResult({
    required this.stock,
    required this.score,
    required this.recommendation,
    required this.stopLossPrice,
    required this.suggestedPosition,
    required this.analysisDetails,
  });

  // 获取推荐等级描述
  String get recommendationText {
    switch (recommendation) {
      case 'strong':
        return '强烈推荐';
      case 'recommended':
        return '推荐';
      case 'cautious':
        return '谨慎';
      case 'not_recommended':
        return '不推荐';
      default:
        return '待分析';
    }
  }

  // 获取推荐等级颜色
  int get recommendationColor {
    switch (recommendation) {
      case 'strong':
        return 0xFF4CAF50; // 绿色
      case 'recommended':
        return 0xFF2196F3; // 蓝色
      case 'cautious':
        return 0xFFFF9800; // 橙色
      case 'not_recommended':
        return 0xFF9E9E9E; // 灰色
      default:
        return 0xFF9E9E9E;
    }
  }

  @override
  String toString() {
    return 'AnalysisResult{stock: $stock, score: $score, recommendation: $recommendation}';
  }
}