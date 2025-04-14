import 'package:beauty_center_frontend/security/secure_storage.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  final Dio _dio;

  DioInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = await SecureStorage.getAccessToken();
    options.headers.addAll({
      "Content-Type": "application/json"
    });

    if(accessToken != null) {
      options.headers.addAll({
        "Authorization": "Bearer $accessToken"
      });
    }
    return super.onRequest(options, handler);
  }

  /*

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async{
    if (err.response?.statusCode == 401) {
      // todo refreshToken

      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        handler.next(e);
      }
      return;
    }
    handler.next(err);
  }


  Future<Response<dynamic>> _retry(RequestOptions requestOptions, String token) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return _dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options
    );
  }

   */
}