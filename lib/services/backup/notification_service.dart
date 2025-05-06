import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  
  // 初始化通知服务
  Future<void> init() async {
    if (_isInitialized) return;
    
    // 初始化时区数据
    tz_data.initializeTimeZones();
    
    // 初始化Android设置
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // 初始化iOS设置
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    // 合并平台设置
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    // 初始化插件，但不使用回调（以避免版本问题）
    await _notificationsPlugin.initialize(
      initSettings
    );
    
    _isInitialized = true;
  }
  
  // 请求通知权限
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await init();
    
    // 请求iOS权限
    final bool? result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        
    return result ?? false;
  }
  
  // 显示即时通知
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await init();
    
    // 通知详情
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'good_mindset_channel',
      '好心态通知',
      channelDescription: '好心态应用的通知频道',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // 显示通知
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  
  // 安排定时通知
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool repeating = false,
    String? payload,
  }) async {
    if (!_isInitialized) await init();
    
    // 通知详情
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'good_mindset_scheduled_channel',
      '好心态定时通知',
      channelDescription: '好心态应用的定时通知频道',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // 转换为时区时间
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    
    // 安排通知
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: repeating ? DateTimeComponents.time : null,
    );
  }
  
  // 安排每日重复通知
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (!_isInitialized) await init();
    
    // 创建时区时间
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    // 如果时间已过，安排到明天
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    // 调用通用定时通知方法
    await scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      repeating: true,
      payload: payload,
    );
  }
  
  // 取消通知
  Future<void> cancelNotification(int id) async {
    if (!_isInitialized) return;
    await _notificationsPlugin.cancel(id);
  }
  
  // 取消所有通知
  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) return;
    await _notificationsPlugin.cancelAll();
  }
} 