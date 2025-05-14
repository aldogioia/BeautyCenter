import 'dart:async';

import 'package:beauty_center_frontend/security/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../handler/navigator_handler.dart';
import '../utils/Strings.dart';

class DioInterceptor extends Interceptor {
  final Dio _refreshDio = Dio();

  // todo svuotare i provider quando il refresh non è valido

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await SecureStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("\n  Response for ${response.requestOptions.path}:\n status: ${response.statusCode}, message: ${response.statusMessage};\n data: ${response.data};\n");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      final refreshToken = await SecureStorage.getRefreshToken();

      if (refreshToken == null) {
        _logout();
        handler.next(err);
        return;
      }

      try {
        final newToken = await _refreshToken(refreshToken);

        if (newToken != null) {
          await SecureStorage.saveAccessToken(newToken);
        } else {
          _logout();
        }
      } catch (_) {
        _logout();
      }
      handler.next(err);
      return;
    }
    handler.next(err);
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await _refreshDio.post(
        'http://${Strings.ip}:8080/api/v1/auth/refresh',
        options: Options(
            headers: {
              'X-Refresh-Token': refreshToken,
            }
        ),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<void> _logout() async {
    await SecureStorage.deleteUserId();
    await SecureStorage.deleteRefreshToken();
    await SecureStorage.deleteAccessToken();
    NavigatorHandler.navigatorKey.currentState?.pushNamedAndRemoveUntil("/start_screen", (Route<dynamic> route) => false);
  }
}