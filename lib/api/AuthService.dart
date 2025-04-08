import 'package:beauty_center_frontend/api/ApiService.dart';
import 'package:dio/dio.dart';

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
}