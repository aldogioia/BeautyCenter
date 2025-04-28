import 'package:edone_customer/pages/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'navigation/navigator.dart';
import 'navigation/route_generator.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        fontFamily: GoogleFonts.quicksand().fontFamily,
      ),
      darkTheme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),

        fontFamily: GoogleFonts.quicksand().fontFamily,
      ),
      navigatorKey: NavigatorService.navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: AuthChecker(),
    );
  }
}
