import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    await notificationPlugin.initialize(settings: initializationSettings);

    final androidPlatform = notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlatform?.requestNotificationsPermission();
    await androidPlatform?.createNotificationChannel(
      const AndroidNotificationChannel(
        'delete_channel',
        'Delete Notifications',
        description: 'Notifications for deleted favorite items',
        importance: Importance.high,
      ),
    );
  }

  Future<void> showDeleteNotification(String spellName) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'delete_channel',
        'Delete Notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await notificationPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: 'Delete notification',
      body: 'You deleted $spellName from your fav list!',
      notificationDetails: notificationDetails,
    );
  }
}
