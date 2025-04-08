import 'dart:io';

import 'package:dio/dio.dart';

import 'ApiService.dart';

class OperatorService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/operator";

  Future<Response?> getAllOperators() async {
    try {
      return await _dio.get("$_path/all");
    } on DioException catch(e){
      return e.response;
    }
  }


  Future<Response?> updateOperator({
    required String id,
    required String name,
    required String surname,
    required String email,
    required File? image,
    required List<String> services
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "id": id,
        "name": name,
        "email": email,
        "surname": surname,
        "services": services,
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

  Future<Response?> createOperator({
    required String name,
    required String surname,
    required String email,
    required File? image,
    required List<String> services
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "surname": surname,
        "email": email,
        "services": services,
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


  Future<Response?> deleteOperator({required String operatorId}) async {
    try {
      return await _dio.delete(
          _path,
          queryParameters: {"operatorId" : operatorId}
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}