import 'package:beauty_center_frontend/screen/booking_step.dart';
import 'package:beauty_center_frontend/screen/navigation_error_screen.dart';
import 'package:beauty_center_frontend/screen/main_screen/main_scaffold.dart';
import 'package:beauty_center_frontend/screen/start_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      case "/start_screen":
        return MaterialPageRoute(builder: (context) => const StartScreen());

      case "/main_scaffold":
        return MaterialPageRoute(builder: (context) => const MainScaffold());   // todo errore col logout

      case "/book":
        return MaterialPageRoute(builder: (context) => BookingStep());

      default:
        return MaterialPageRoute(builder: (context) => const NavigationErrorScreen());
    }
  }
}