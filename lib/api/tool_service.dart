import 'package:dio/dio.dart';

import 'api_service.dart';

class ToolService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/tool";

  
  Future<Response?> createTool({required String name, required int availability}) async {
    try {
      return await _dio.post(
        _path,
        data: {
          'name': name,
          'availability': availability
        }
      );
    } on DioException catch(e) {
      return e.response;
    }
  }
  
  
  Future<Response?> updateTool({required String id, required String name, required int availability}) async {
    try {
      return await _dio.put(
        _path,
        data: {
          'id': id,
          'name': name,
          'availability': availability
        }
      );
    } on DioException catch(e){
      return e.response;
    }
  }


  Future<Response?> deleteTool({required String id}) async {
    try {
      return await _dio.delete(
        _path,
        queryParameters: {
          'id': id
        }
      );
    } on DioException catch(e) {
      return e.response;
    }
  }


  Future<Response?> getAllTools() async {
    try {
      return await _dio.get(
        _path
      );
    } on DioException catch(e) {
      return e.response;
    }
  }
}