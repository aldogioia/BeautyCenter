import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../utils/secure_storage.dart';

class NotificationHandler {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static final MethodChannel _channel = MethodChannel('com.example.exact_alarm/permission');

  static Future<void> openExactAlarmSettings() async {
    try {
      await _channel.invokeMethod('requestExactAlarmPermission');
    } on PlatformException catch (e) {
      print("Errore nel richiedere il permesso: $e");
    }
  }

  static void checkAndRequestExactAlarmPermission() async {
    final plugin = FlutterLocalNotificationsPlugin();

    bool allowed = await plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.canScheduleExactNotifications() ??
        false;

    if (!allowed) {
      await openExactAlarmSettings();
    }
  }



  static Future<void> handleNotificationPermissions() async {
    final iosPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    bool? granted = false;

    if (iosPlugin != null) {
      granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (androidPlugin != null) {
      final status = await Permission.notification.request();
      granted = status.isGranted;
    }

    await SecureStorage.setNotificationsEnabled(granted ?? false);
  }

  static Future<void> scheduleBookingNotifications({
    required DateTime appointmentDateTime,
  }) async {
    final reminders = [
      Duration(hours: 2),
      Duration(hours: 1),
      Duration(minutes: 30),
    ];

    for (final duration in reminders) {
      final scheduledTime = appointmentDateTime.subtract(duration);

      if (scheduledTime.isAfter(DateTime.now())) {
        await _plugin.zonedSchedule(
          scheduledTime.hashCode, // Unique ID
          "Promemoria appuntamento",
          "Hai un appuntamento tra ${duration.inMinutes > 30 ? "${duration.inHours} ore" : "${duration.inMinutes} minuti."}",
          tz.TZDateTime.from(scheduledTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'booking_channel',
              'Promemoria appuntamenti',
              channelDescription: 'Notifiche per appuntamenti imminenti',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }
    }
  }

  static Future<void> cancelBookingNotifications(DateTime appointmentDateTime) async {
    final reminders = [
      Duration(hours: 2),
      Duration(hours: 1),
      Duration(minutes: 30),
    ];

    for (final duration in reminders) {
      final scheduledTime = appointmentDateTime.subtract(duration);
      final notificationId = scheduledTime.hashCode;

      await _plugin.cancel(notificationId);
    }
  }
}
