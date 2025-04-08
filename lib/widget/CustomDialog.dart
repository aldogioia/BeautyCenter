import 'package:flutter/material.dart';

class CustomDialog {
  static void show({required Widget child, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: child,
        );
      }
    );
  }
}