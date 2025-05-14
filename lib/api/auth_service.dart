import 'package:beauty_center_frontend/api/api_service.dart';
import 'package:dio/dio.dart';

import '../security/secure_storage.dart';
import '../utils/strings.dart';

class AuthService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/auth";

  Future<Response?> login({required String email, required String password}) async {
    try {
      return await _dio.post(
          "$_path/sign-in",
          queryParameters: {
            'email' : email,
            'password' : password
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }


  // todo token notifiche
  Future<Response?> logout() async {
    try {
      return await _dio.post("$_path/sign-out");
    } on DioException catch(e){
      return e.response;
    }
  }
}