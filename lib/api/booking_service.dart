import 'package:dio/dio.dart';

import 'api_service.dart';


class BookingService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/booking";

  Future<Response?> getCustomerBookings(String customerId) async {
    try {
      return await _dio.get(
          "$_path/customer",
          queryParameters: {
            'customerId' : customerId
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> newBooking({
    required String? customerId,
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
            'date' : date,
            'time' : time,
            'service' : serviceId,
            'operator' : operatorId,
            'bookedForCustomer': customerId,
            'bookedForName' : nameGuest,
            'bookedForNumber' : phoneNumberGuest,
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> deleteBooking(String bookingId) async {
    try {
      return await _dio.delete(
          _path,
          queryParameters: {
            'customerId': bookingId
          }
      );
    } on DioException catch (e) {
      return e.response;
    }
  }
}