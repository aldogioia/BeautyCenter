import 'package:beauty_center_frontend/widget/modal-bottom-sheet/login_modal_bottom_sheet.dart';
import 'package:beauty_center_frontend/screen/navigation_error_screen.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/reset_password_modal_bottom_sheet.dart';
import 'package:beauty_center_frontend/screen/main_screen/main_scaffold.dart';
import 'package:beauty_center_frontend/screen/start_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch(settings.name){
      case "/start_screen":
        return MaterialPageRoute(builder: (context) => const StartScreen());

      case "/main_scaffold":
        return MaterialPageRoute(builder: (context) => const MainScaffold());

      default:
        return MaterialPageRoute(builder: (context) => const NavigationErrorScreen());
    }
  }
}