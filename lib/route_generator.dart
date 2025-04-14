import 'package:beauty_center_frontend/screen/LoginScreen.dart';
import 'package:beauty_center_frontend/screen/NavigationErrorScreen.dart';
import 'package:beauty_center_frontend/screen/SetPasswordScreen.dart';
import 'package:beauty_center_frontend/screen/main_screen/BookingScreen.dart';
import 'package:beauty_center_frontend/screen/main_screen/EntitiesManagementScreen.dart';
import 'package:beauty_center_frontend/screen/main_screen/ScheduleScreen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;  // todo forse si possono rimuovere

    switch(settings.name){
      case "/login":
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case "/set_password":
        return MaterialPageRoute(builder: (context) => const SetPasswordScreen());

      case "/entities_management_screen":
        return MaterialPageRoute(builder: (context) => const EntitiesManagementScreen());

      case "/schedule_screen":
        return MaterialPageRoute(builder: (context) => const ScheduleScreen());

      case "/booking_screen":
        return MaterialPageRoute(builder: (context) => const BookingScreen());

      default:
        return MaterialPageRoute(builder: (context) => const NavigationErrorScreen());    //todo
    }
  }
}