import 'package:dio/dio.dart';
import '../api/api_service.dart';
import '../api/auth_service.dart';
import '../navigation/navigator.dart';
import '../utils/secure_storage.dart';

class DioInterceptor extends Interceptor {
  final AuthService _authService = AuthService();

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
      final refreshResp = await _authService.refresh();

      if (refreshResp?.statusCode == 200) {
        var rawAuth = refreshResp!.headers.value('Authorization');
        var rawRefresh = refreshResp.headers.value('X-Refresh-Token');
        if (rawAuth == null || rawRefresh == null) {
          return handler.next(err);
        }
        final newAccess = rawAuth.startsWith('Bearer ')
            ? rawAuth.substring(7)
            : rawAuth;

        await SecureStorage.setAccessToken(newAccess);
        await SecureStorage.setRefreshToken(rawRefresh);

        opts.extra['retry'] = true;
        final newOpts = Options(
          method: opts.method,
          headers: {
            ...opts.headers,
            'Authorization': 'Bearer $newAccess',
          },
        );
        final clone = await ApiService.instance.dio.request(
          opts.path,
          options: newOpts,
          data: opts.data,
          queryParameters: opts.queryParameters,
        );
        return handler.resolve(clone);
      }

      await SecureStorage.clearAll();
      NavigatorService.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/signin', (route) => false);
    }

    handler.next(err);
  }
}
