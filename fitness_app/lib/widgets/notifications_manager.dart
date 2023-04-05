import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void scheduleDailyNotification() {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'gym_notification_channel',
    'Gym Notifications',
    channelDescription: 'Reminders to go and train at the gym',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  final DateTime now = DateTime.now();
  final DateTime scheduledDate = DateTime(now.year, now.month, now.day, 8,);

  if (scheduledDate.isBefore(now)) {
    // Schedule notification for the next day if the current time is past 10 AM
    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time to train',
        'Don\'t forget to go to the gym and train today!',
        tz.TZDateTime.from(scheduledDate.add(Duration(days: 1)), tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  } else {
    // Schedule notification for the current day
    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time to train',
        'Don\'t forget to go to the gym and train today!',
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}