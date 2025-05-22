import 'package:edone_customer/handler/firebase_handler.dart';
import 'package:edone_customer/pages/auth_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'firebase_options.dart';
import 'handler/notification_handler.dart';
import 'navigation/navigator.dart';
import 'navigation/route_generator.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(FirebaseHandler.firebaseMessagingBackgroundHandler);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Rome'));

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  final iOSInit = DarwinInitializationSettings();
  final initSettings = InitializationSettings(android: androidInit, iOS: iOSInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await NotificationHandler.handleNotificationPermissions();
  await FirebaseHandler.initFCM();

  FlutterNativeSplash.remove();
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),

        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      darkTheme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),

        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      navigatorKey: NavigatorService.navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: AuthChecker(),
    );
  }
}
