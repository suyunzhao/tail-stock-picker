class TimeUtils {
  // 检查当前是否在交易时间内
  static bool isTradingTime() {
    final now = DateTime.now();
    final isWeekday = now.weekday >= 1 && now.weekday <= 5; // 周一到周五
    
    if (!isWeekday) return false;
    
    final currentTime = now.hour * 100 + now.minute;
    
    // A股交易时间: 9:30-11:30, 13:00-15:00
    final isMorning = currentTime >= 930 && currentTime <= 1130;
    final isAfternoon = currentTime >= 1300 && currentTime <= 1500;
    
    return isMorning || isAfternoon;
  }
  
  // 检查是否在尾盘分析时间段
  static bool isTailAnalysisTime() {
    final now = DateTime.now();
    final isWeekday = now.weekday >= 1 && now.weekday <= 5;
    
    if (!isWeekday) return false;
    
    final currentTime = now.hour * 100 + now.minute;
    
    // 尾盘分析时间: 14:25-14:35
    return currentTime >= 1425 && currentTime <= 1435;
  }
  
  // 获取下一个分析时间
  static DateTime getNextAnalysisTime() {
    final now = DateTime.now();
    DateTime nextTime = DateTime(now.year, now.month, now.day, 
        AppConstants.analysisStartHour, AppConstants.analysisStartMinute);
    
    if (now.isAfter(nextTime)) {
      nextTime = nextTime.add(Duration(days: 1));
    }
    
    // 如果是周末，调整到下一个周一
    while (nextTime.weekday == 6 || nextTime.weekday == 7) {
      nextTime = nextTime.add(Duration(days: 1));
    }
    
    return nextTime;
  }

  // 格式化时间显示
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // 计算距离指定时间的差值（分钟）
  static int minutesUntil(DateTime targetTime) {
    final now = DateTime.now();
    final difference = targetTime.difference(now);
    return difference.inMinutes;
  }

  // 检查是否是交易日
  static bool isTradingDay() {
    final now = DateTime.now();
    return now.weekday >= 1 && now.weekday <= 5; // 周一到周五
  }

  // 获取当前交易时段
  static String getCurrentTradingSession() {
    final now = DateTime.now();
    final currentTime = now.hour * 100 + now.minute;
    
    if (currentTime < 930) return '开盘前';
    if (currentTime <= 1130) return '上午交易';
    if (currentTime < 1300) return '午间休市';
    if (currentTime <= 1500) return '下午交易';
    return '收盘后';
  }
}