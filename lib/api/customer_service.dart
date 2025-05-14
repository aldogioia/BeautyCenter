import 'package:dio/dio.dart';

import 'api_service.dart';

class CustomerService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/customer";

  Future<Response?> getAllCustomers() async {
    try {
      return await _dio.get("$_path/all");
    } on DioException catch(e){
      return e.response;
    }
  }


  Future<Response?> updateCustomer({
    required String id,
    required String name,
    required String surname,
    required String email,
    required String phoneNumber
  }) async {
    try {
      final data = {
        'id': id,
        'name': name,
        'surname': surname,
        'email': email,
        'phoneNumber': phoneNumber
      };
      return await _dio.patch(_path, data: data);
    } on DioException catch(e){
      return e.response;
    }
  }
}