import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api_service.dart';

class PasswordService{
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/password";

  Future<Response?> sendEmail(String email) async {
    try {
      return await _dio.post(
          "$_path/request-reset",
          queryParameters: {
            'email' : email
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> resetPassword(String token, String password) async {
    try {
      return await _dio.patch(
          "$_path/reset",
          queryParameters: {
            'token' : token,
            'password' : password
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> updatePassword(String customerId, String oldPassword, String newPassword) async {
    debugPrint("sto facendo la chiamata");
    try {
      return await _dio.patch(
          "$_path/update-password",
          data: {
            'userId' : customerId,
            'oldPassword' : oldPassword,
            'newPassword' : newPassword
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}