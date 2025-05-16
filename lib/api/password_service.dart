import 'package:dio/dio.dart';

import 'api_service.dart';

class PasswordService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/password";

  Future<Response?> requestReset({required String email}) async {
    try {
      return await _dio.post(
        "$_path/request-reset",
        queryParameters: {
          'email' : email
        }
      );
    } on DioException catch(e){
      print("Errore: $e");
      return e.response;
    }
  }

  Future<Response?> reset({required String token, required String password}) async {
    try {
      return await _dio.patch(
          "$_path/reset",
          queryParameters: {
            'token' : token,
            'password' : password
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}