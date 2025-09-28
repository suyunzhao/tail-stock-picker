class Stock {
  final String code;           // 股票代码
  final String name;           // 股票名称
  final double currentPrice;   // 当前价格
  final double changePercent;  // 涨跌幅
  final double volumeRatio;    // 量比
  final double turnoverRate;   // 换手率
  final double marketCap;      // 流通市值（亿）
  final double highPrice;      // 当日最高价
  final double lowPrice;       // 当日最低价
  final double openPrice;      // 开盘价
  final double closePrice;     // 昨日收盘价
  final double volume;         // 成交量（手）
  final double amount;         // 成交额（万）
  final bool isMultiLineArrangement; // 是否多头排列
  final bool isNewHigh;        // 是否创新高
  final double relativeStrength; // 相对强度
  final DateTime updateTime;   // 数据更新时间

  Stock({
    required this.code,
    required this.name,
    required this.currentPrice,
    required this.changePercent,
    required this.volumeRatio,
    required this.turnoverRate,
    required this.marketCap,
    required this.highPrice,
    required this.lowPrice,
    required this.openPrice,
    required this.closePrice,
    required this.volume,
    required this.amount,
    required this.isMultiLineArrangement,
    required this.isNewHigh,
    required this.relativeStrength,
    required this.updateTime,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      currentPrice: double.tryParse(json['currentPrice']?.toString() ?? '0') ?? 0,
      changePercent: double.tryParse(json['changePercent']?.toString() ?? '0') ?? 0,
      volumeRatio: double.tryParse(json['volumeRatio']?.toString() ?? '0') ?? 0,
      turnoverRate: double.tryParse(json['turnoverRate']?.toString() ?? '0') ?? 0,
      marketCap: double.tryParse(json['marketCap']?.toString() ?? '0') ?? 0,
      highPrice: double.tryParse(json['highPrice']?.toString() ?? '0') ?? 0,
      lowPrice: double.tryParse(json['lowPrice']?.toString() ?? '0') ?? 0,
      openPrice: double.tryParse(json['openPrice']?.toString() ?? '0') ?? 0,
      closePrice: double.tryParse(json['closePrice']?.toString() ?? '0') ?? 0,
      volume: double.tryParse(json['volume']?.toString() ?? '0') ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      isMultiLineArrangement: json['isMultiLineArrangement'] ?? false,
      isNewHigh: json['isNewHigh'] ?? false,
      relativeStrength: double.tryParse(json['relativeStrength']?.toString() ?? '0') ?? 0,
      updateTime: DateTime.parse(json['updateTime'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'currentPrice': currentPrice,
      'changePercent': changePercent,
      'volumeRatio': volumeRatio,
      'turnoverRate': turnoverRate,
      'marketCap': marketCap,
      'highPrice': highPrice,
      'lowPrice': lowPrice,
      'openPrice': openPrice,
      'closePrice': closePrice,
      'volume': volume,
      'amount': amount,
      'isMultiLineArrangement': isMultiLineArrangement,
      'isNewHigh': isNewHigh,
      'relativeStrength': relativeStrength,
      'updateTime': updateTime.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Stock{code: $code, name: $name, price: $currentPrice, change: $changePercent%}';
  }
}