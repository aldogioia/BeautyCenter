import 'package:beauty_center_frontend/security/dio_interceptor.dart';
import 'package:dio/dio.dart';

import '../utils/Strings.dart';

class ApiService {
  static final ApiService _instance = ApiService._privateConstructor();

  late final Dio dio;

  ApiService._privateConstructor() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://${Strings.ip}:8080/api/v1',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {"Content-Type": "application/json"}
    ));

    dio.interceptors.add(DioInterceptor());
  }

  static ApiService get instance => _instance;
}