import 'package:dio/dio.dart';
import '../navigation/navigator.dart';
import '../utils/secure_storage.dart';

class DioInterceptor extends Interceptor {
  final Dio _dio;

  DioInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final opts = err.requestOptions;

    if (statusCode == 401 && opts.extra['retry'] != true) {
      final refreshToken = await SecureStorage.getRefreshToken();

      if (refreshToken == null) {
        await SecureStorage.clearAll();
        NavigatorService.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil('/sign-in', (route) => false);
        return handler.next(err);
      }

      try {
        final refreshResponse = await _dio.post(
          '/auth/refresh',
          options: Options(
            headers: {
              'X-Refresh-Token': refreshToken,
            },
          ),
        );

        var rawAuth = refreshResponse.headers.value('Authorization');
        var rawRefresh = refreshResponse.headers.value('X-Refresh-Token');

        if (rawAuth == null || rawRefresh == null) {
          await SecureStorage.clearAll();
          NavigatorService.navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/sign-in', (route) => false);
          return handler.next(err);
        }

        final newAccess = rawAuth.startsWith('Bearer ')
            ? rawAuth.substring(7)
            : rawAuth;

        await SecureStorage.setAccessToken(newAccess);
        await SecureStorage.setRefreshToken(rawRefresh);

        opts.extra['retry'] = true;

        final newOptions = Options(
          method: opts.method,
          headers: {
            ...opts.headers,
            'Authorization': 'Bearer $newAccess',
          },
        );

        final clone = await _dio.request(
          opts.path,
          options: newOptions,
          data: opts.data,
          queryParameters: opts.queryParameters,
        );

        return handler.resolve(clone);
      } on DioException catch (_) {
        await SecureStorage.clearAll();
        NavigatorService.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil('/sign-in', (route) => false);
        return handler.next(err);
      }
    }

    handler.next(err);
  }

}
