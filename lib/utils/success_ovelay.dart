import 'package:edone_customer/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showSuccessOverlay() {
  final context = NavigatorService.navigatorKey.currentState?.overlay?.context;
  if (context == null) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      Future.delayed(const Duration(seconds: 3), () {
        NavigatorService.navigatorKey.currentState?.pop();
      });
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Lottie.asset(
            "assets/lottie/book.json",
            height: 100,
            repeat: false,
          )
        ),
      );
    },
  );
}
