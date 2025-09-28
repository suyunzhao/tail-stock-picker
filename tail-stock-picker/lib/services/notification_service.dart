import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _notifications;

  Future<void> init() async {
    _notifications = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> showAnalysisCompleteNotification(int stockCount) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'analysis_channel',
      '股票分析通知',
      channelDescription: '尾盘选股分析结果通知',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      '🎯 尾盘选股分析完成',
      '发现$stockCount只符合条件股票，点击查看详情',
      details,
    );
  }

  Future<void> scheduleDailyReminder() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      '每日提醒',
      channelDescription: '尾盘选股每日提醒',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 每天14:25提醒
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      14, // 小时
      25, // 分钟
    );

    // 如果今天已经过了14:25，就安排到明天
    if (scheduledTime.isBefore(now)) {
      scheduledTime.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      1,
      '⏰ 尾盘选股提醒',
      '即将开始尾盘选股分析，请做好准备',
      TZDateTime.from(scheduledTime, await _getLocalTimeZone()),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<String> _getLocalTimeZone() async {
    // 简化实现，实际应该获取设备时区
    return 'Asia/Shanghai';
  }
}