import 'package:dio/dio.dart';

import 'dio_interceptor.dart';

class ApiService {
  static final ApiService _instance = ApiService._privateConstructor();

  late final Dio dio;

  ApiService._privateConstructor() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8080/api/v1',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 3),
      )
    );

    dio.interceptors.add(DioInterceptor(dio));
  }

  static ApiService get instance => _instance;
}
