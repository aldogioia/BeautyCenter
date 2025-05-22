import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api_service.dart';

class FirebaseService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/notifications";

  Future<void> sendFCMToken({required String token}) async {
    final platform = Platform.isAndroid ? "android" : "ios";
    print("SONO IN");
    try {
      final response = await _dio.post(
        _path,
        data: {
          "token": token,
          "platform": platform
        },
      );
      print("RESPONSE: $response");
    } on DioException catch(e){
      debugPrint("ERRRRROOOOOOREOEROFSIabvak: ${e.response.toString()}");
    }
  }
}
