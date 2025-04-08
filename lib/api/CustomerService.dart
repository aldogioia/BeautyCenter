import 'package:dio/dio.dart';

import '../model/UpdateCustomerDto.dart';
import 'ApiService.dart';

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


  Future<Response?> updateCustomer({required UpdateCustomerDto updateCustomerDto}) async {
    try {
      return await _dio.patch(_path, data: updateCustomerDto.toJson());
    } on DioException catch(e){
      return e.response;
    }
  }
}