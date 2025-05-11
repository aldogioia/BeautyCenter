import 'package:fluttertoast/fluttertoast.dart';

class SnackBarHandler {
  static final SnackBarHandler _instance = SnackBarHandler._privateConstructor();

  SnackBarHandler._privateConstructor();

  static SnackBarHandler get instance => _instance;

  void showMessage({required String message}){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

}