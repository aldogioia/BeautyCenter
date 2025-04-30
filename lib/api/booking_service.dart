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

  Future<Response?> newBooking({
    required String customerId,
    required String operatorId,
    required String serviceId,
    required String? nameGuest,
    required String? phoneNumberGuest,
    required String date,
    required String time
  }) async {
    try {
      return await _dio.post(
          _path,
          data: {
            'customerId' : customerId,
            'operatorId' : operatorId,
            'serviceId' : serviceId,
            'nameGuest' : nameGuest,
            'phoneNumberGuest' : phoneNumberGuest,
            'date' : date,
            'time' : time
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}