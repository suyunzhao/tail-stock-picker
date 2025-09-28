import 'package:flutter/material.dart';

class Helpers {
  // 显示提示信息
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 格式化数字，保留小数位
  static String formatNumber(double number, {int decimalDigits = 2}) {
    return number.toStringAsFixed(decimalDigits);
  }

  // 计算涨幅颜色
  static Color getChangeColor(double change) {
    if (change > 0) return Color(0xFFE53935);
    if (change < 0) return Color(0xFF4CAF50);
    return Colors.grey;
  }

  // 验证股票代码格式
  static bool isValidStockCode(String code) {
    final regExp = RegExp(r'^(sh|sz)\d{6}$');
    return regExp.hasMatch(code);
  }

  // 从股票代码中提取纯数字代码
  static String getPureStockCode(String code) {
    if (code.length >= 8) {
      return code.substring(2);
    }
    return code;
  }

  // 获取推荐等级颜色
  static Color getRecommendationColor(String recommendation) {
    switch (recommendation) {
      case 'strong':
        return Color(0xFF4CAF50);
      case 'recommended':
        return Color(0xFF2196F3);
      case 'cautious':
        return Color(0xFFFF9800);
      case 'not_recommended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // 格式化时间差为可读字符串
  static String formatTimeDifference(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }

  // 计算百分比变化
  static double calculatePercentChange(double oldValue, double newValue) {
    if (oldValue == 0) return 0.0;
    return ((newValue - oldValue) / oldValue) * 100;
  }
}