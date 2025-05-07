import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../navigation/navigator.dart';
import '../utils/secure_storage.dart';

class DioInterceptor extends Interceptor {
  final Dio _dio;
  final Dio _refreshDio = Dio();

  bool _isRefreshing = false;
  late List<void Function(String)> _retryQueue;

  DioInterceptor(this._dio) {
    _retryQueue = [];
  }

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

      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final newToken = await _refreshToken(refreshToken);
          if (newToken != null) {
            await SecureStorage.setAccessToken(newToken);
            for (var retry in _retryQueue) {
              retry(newToken);
            }
            _retryQueue.clear();
          } else {
            _logout();
          }
        } catch (_) {
          _logout();
        } finally {
          _isRefreshing = false;
        }
      }

      final clonedRequest = await _retryRequest(err.requestOptions);
      handler.resolve(clonedRequest);

      return;
    }

    handler.next(err);
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await _refreshDio.post(
        'http://192.168.1.14:8080/api/v1/auth/refresh',
        options: Options(headers: {
          'X-Refresh-Token': refreshToken,
        }),
      );
      return response.data;
    } catch (e) {
      debugPrint('Refresh token failed: $e');
      return null;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final completer = Completer<Response<dynamic>>();

    _retryQueue.add((String token) async {
      try {
        final options = Options(
          method: requestOptions.method,
          headers: {
            ...requestOptions.headers,
            'Authorization': 'Bearer $token',
          },
        );
        final response = await _dio.request<dynamic>(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options,
        );
        completer.complete(response);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
  }

  void _logout() {
    SecureStorage.clearAll();
    NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil('/sign-in', (route) => false);
  }
}
