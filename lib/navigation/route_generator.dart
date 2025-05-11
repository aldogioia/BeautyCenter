import 'package:edone_customer/pages/custom_widgets/booking_step.dart';
import 'package:edone_customer/pages/password_recovery_page.dart';
import 'package:flutter/material.dart';

import '../pages/new_password_page.dart';
import '../pages/sign_in_page.dart';
import '../pages/sign_up_page.dart';
import '../pages/scaffold_page.dart';
import '../pages/start_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name){
      case "/scaffold":
        return MaterialPageRoute(builder: (context) => const ScaffoldPage());

      case "/start":
        return MaterialPageRoute(builder: (context) => const StartPage());

      case "/sign-in":
        return MaterialPageRoute(builder: (context) => const SignInPage());

      case "/sign-up":
        return MaterialPageRoute(builder: (context) => const SignUpPage());

      case "/password-recovery":
        return MaterialPageRoute(builder: (context) => const PasswordRecoveryPage());

      case "/new-password":
        final arg = settings.arguments as String;
        return MaterialPageRoute(builder: (context) => NewPasswordPage(token: arg));

      case "/booking":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => BookingStep(
          serviceId: args['serviceId'], serviceImage: args['serviceImage'])
        );

      default:
        return MaterialPageRoute(builder: (context) => Text("Errore di navigazione"));
    }
  }
}