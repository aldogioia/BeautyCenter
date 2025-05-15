import 'package:edone_customer/api/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import '../utils/secure_storage.dart';

class FirebaseHandler {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    showRemoteNotification(message);
  }

  static Future<void> initFCM() async {
    await _messaging.requestPermission();

    final fcmToken = await _messaging.getToken();
    if (fcmToken != null) {
      final savedToken = await SecureStorage.getFCMToken();
      if (fcmToken != savedToken) {
        await FirebaseService().sendFCMToken(token: fcmToken);
        await SecureStorage.setFCMToken(fcmToken);
      }
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await FirebaseService().sendFCMToken(token: newToken);
      await SecureStorage.setFCMToken(newToken);
    });

    FirebaseMessaging.onMessage.listen(showRemoteNotification);
  }

  static void showRemoteNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'remote_channel',
            'Notifiche Push',
            channelDescription: 'Notifiche inviate dal server',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }
}
