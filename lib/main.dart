import 'package:beauty_center_frontend/handler/navigator_handler.dart';
import 'package:beauty_center_frontend/screen/auth_checker.dart';
import 'package:beauty_center_frontend/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'handler/notification_handler.dart';
import 'route_generator.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Rome'));

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  final iOSInit = DarwinInitializationSettings();

  var initSettings = InitializationSettings(
    android: androidInit,
    iOS: iOSInit,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await NotificationHandler.handleNotificationPermissions();
  
  runApp(
    ProviderScope(
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Rome'));

    return MaterialApp(
      locale: const Locale('it', 'IT'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('it', 'IT'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: NavigatorHandler.navigatorKey,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,

        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: AppColors.primary,
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        iconTheme: IconThemeData(
          size: 24,
          color: AppColors.black
        ),
        shadowColor: AppColors.black.withAlpha((255 * 0.1).toInt()),
        fontFamily: GoogleFonts.poppins().fontFamily,

      inputDecorationTheme: InputDecorationTheme(
          errorMaxLines: 10,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.black.withAlpha((255 * 0.1).toInt())),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.black.withAlpha((255 * 0.1).toInt())),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.black.withAlpha((255* 0.1).toInt())),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5)
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.red, width: 1.5),
          ),
          prefixIconColor: AppColors.black,
          labelStyle: TextStyle(fontSize: 12, color: AppColors.black.withAlpha((255 * 0.5.toInt())), fontWeight: FontWeight.normal),
          hintStyle: TextStyle(fontSize: 12, color: AppColors.black.withAlpha((255 * 0.5.toInt())), fontWeight: FontWeight.normal),
          errorStyle: TextStyle(fontSize: 12, color: AppColors.red, fontWeight: FontWeight.normal, overflow: TextOverflow.visible)
        ),

        useMaterial3: true,
      ),


      darkTheme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        iconTheme: IconThemeData(
          size: 24,
          color: AppColors.white
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,

        inputDecorationTheme: InputDecorationTheme(
            errorMaxLines: 10,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.white.withAlpha((255 * 0.1).toInt())),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.white.withAlpha((255 * 0.1).toInt())),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.white.withAlpha((255 * 0.1).toInt())),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5)
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
            prefixIconColor: AppColors.white,
            labelStyle: TextStyle(fontSize: 12, color: AppColors.white.withAlpha((255 * 0.5).toInt()), fontWeight: FontWeight.normal),
            hintStyle: TextStyle(fontSize: 12, color: AppColors.white.withAlpha((255 * 0.5).toInt()), fontWeight: FontWeight.normal),
            errorStyle: TextStyle(fontSize: 12, color: AppColors.red, fontWeight: FontWeight.normal, overflow: TextOverflow.visible)
        ),

        useMaterial3: true,
      ),
      home: AuthChecker(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

