import 'package:dio/dio.dart';

import 'api_service.dart';

class ServiceService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/service";

  Future<Response?> getAllServices() async {
    try {
      return await _dio.get("$_path/all");
    } on DioException catch(e){
      return e.response;
    }
  }
}