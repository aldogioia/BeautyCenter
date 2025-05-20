import 'package:dio/dio.dart';
import '../utils/secure_storage.dart';
import 'api_service.dart';

class AuthService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/auth";

  Future<Response?> signIn({required String phoneNumber, required String password}) async {
    try {
      return await _dio.post(
        "$_path/sign-in",
        queryParameters: {
          'phoneNumber': phoneNumber,
          'password': password
        },
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> signUp({
    required String name,
    required String surname,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      return await _dio.post(
        "$_path/sign-up",
        data: {
          'name': name,
          'surname': surname,
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> signOut() async {
    final accessToken = await SecureStorage.getAccessToken();
    final refreshToken = await SecureStorage.getRefreshToken();
    if (refreshToken == null || accessToken == null) {
      return null;
    }
    try {
      return await _dio.post(
        "$_path/sign-out",
        options: Options(headers: {
          'X-Refresh-Token': refreshToken,
        }),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> refresh({required String refreshToken}) async {
    try {
      return await _dio.post(
        "$_path/refresh",
        options: Options(headers: {
          'X-Refresh-Token': refreshToken,
        }),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }
}
