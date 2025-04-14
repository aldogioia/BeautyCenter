import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_colors.dart';

class SnackBarHandler {
  static final SnackBarHandler _instance = SnackBarHandler._privateConstructor();

  SnackBarHandler._privateConstructor();

  static SnackBarHandler get instance => _instance;

  void showMessage({required String message}){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,    // todo prendere dal tema
      textColor: AppColors.white,     // todo prendere dal tema
    );
  }

}