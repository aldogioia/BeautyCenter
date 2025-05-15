import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api_service.dart';

class FirebaseService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/operator";

  Future<void> sendFCMToken({required String token}) async {
    final platform = Platform.isAndroid ? "android" : "ios";

    try {
      await _dio.post(
        "$_path/notifications",
        data: {
          "token": token,
          "platform": platform
        },
      );
    } on DioException catch(e){
      debugPrint(e.response.toString());
    }
  }
}
