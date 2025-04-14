import 'dart:io';

import 'package:beauty_center_frontend/api/api_service.dart';
import 'package:dio/dio.dart';


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

  Future<Response?> updateService({
    required String id,
    required String name,
    required double price,
    required int duration,
    required File? image
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "id": id,
        "name": name,
        "price": price,
        "duration": duration,
        if(image != null)
          "image": await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      });
      return await _dio.patch(
        _path,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"})
      );
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> createService({
    required String name,
    required double price,
    required int duration,
    required File? image
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "price": price,
        "duration": duration,
        if(image != null)
          "image": await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      });

      return await _dio.post(
        _path,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"})
      );
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> deleteService({required String serviceId}) async {
    try {
      return await _dio.delete(
        _path,
        queryParameters: {"serviceId" : serviceId}
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}