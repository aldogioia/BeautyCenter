import 'package:beauty_center_frontend/handler/navigator_handler.dart';
import 'package:beauty_center_frontend/screen/auth_checker.dart';
import 'package:beauty_center_frontend/screen/main_screen/main_scaffold.dart';
import 'package:beauty_center_frontend/screen/main_screen/schedule_screen.dart';
import 'package:beauty_center_frontend/screen/start_screen.dart';
import 'package:beauty_center_frontend/security/secure_storage.dart';
import 'package:beauty_center_frontend/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'route_generator.dart';

void main() {
  
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
            borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)),
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
          labelStyle: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.5), fontWeight: FontWeight.normal),
          hintStyle: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.5), fontWeight: FontWeight.normal),
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
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
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

