import 'package:dio/dio.dart';

import '../utils/secure_storage.dart';
import 'api_service.dart';

class CustomerService{
  final Dio _dio = ApiService.instance.dio;
  final path = "/customer";

  Future<Response?> getCustomer() async {
    final userId = await SecureStorage.getUserId();

    try {
      return await _dio.get(
        "$path/one",
        queryParameters: {
          'id': userId,
        },
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> updateCustomer({
    required String name,
    required String surname,
    required String phoneNumber,
  }) async {
    final userId = await SecureStorage.getUserId();
    try {
      return await _dio.patch(
        path,
        data: {
          'id': userId,
          'name': name,
          'surname': surname,
          'phoneNumber': phoneNumber,
        },
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> deleteCustomer() async {
    final userId = await SecureStorage.getUserId();
    try {
      return await _dio.delete(
        path,
        queryParameters: {
          'id': userId,
        },
      );
    } on DioException catch (e) {
      return e.response;
    }
  }
}