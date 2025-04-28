import 'package:dio/dio.dart';

import 'api_service.dart';


class BookingService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/booking";

  Future<Response?> getCustomerBookings({required String customerId}) async {
    try {
      return await _dio.get(
          _path,
          queryParameters: {
            'customerId' : customerId
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}