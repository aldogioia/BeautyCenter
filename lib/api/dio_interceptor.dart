import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../navigation/navigator.dart';
import '../utils/Strings.dart';
import '../utils/secure_storage.dart';

class DioInterceptor extends Interceptor {
  final Dio _refreshDio = Dio();

  DioInterceptor();

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
          await SecureStorage.setAccessToken(newToken);
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

  void _logout() {
    SecureStorage.clearAll();
    NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil('/sign-in', (route) => false);
  }
}
