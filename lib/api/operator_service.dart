import 'package:dio/dio.dart';

import 'api_service.dart';


class OperatorService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/operator";

  Future<Response?> getAllOperators(String serviceId) async {
    try {
      return await _dio.get(
          "$_path/byService",
          queryParameters: {
            'serviceId' : serviceId,
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> getAvailableTimes(
    String operatorId,
    String serviceId,
    String date,
  ) async {
    try {
      return await _dio.get(
        "$_path/availableTimes",
        queryParameters: {
          'operatorId' : operatorId,
          'serviceId' : serviceId,
          'date' : date,
        }
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}