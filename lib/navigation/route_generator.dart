import 'package:flutter/material.dart';

import '../pages/scaffold_page.dart';
import '../pages/sign_in_page.dart';
import '../pages/sign_up_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch(settings.name){
      case "/scaffold":
        return MaterialPageRoute(builder: (context) => const ScaffoldPage());

      case "/sign_in":
        return MaterialPageRoute(builder: (context) => const SignInPage());

      case "/sign_up":
        return MaterialPageRoute(builder: (context) => const SignUpPage());

      default:
        return MaterialPageRoute(builder: (context) => Text("Errore di navigazione"));
    }
  }
}