import 'package:beauty_center_frontend/utils/time_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';

class BookingService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/booking";

  Future<Response?> getOperatorBookings({required String operatorId, required DateTime date}) async {
    try {
      return await _dio.get(
          "$_path/operator",
          queryParameters: {
            'operatorId' : operatorId,
            'date' : date.toIso8601String().split('T').first
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }


  Future<Response?> createBooking({
    required DateTime date,
    required TimeOfDay time,
    required String service,
    required String operator,
    String? nameGuest,
    String? phoneNumberGuest,
  }) async {
    try {
      final data = {
        'date': date.toIso8601String().split('T').first,
        'time': TimeUtils.formatTimeOfDay(time),
        'service': service,
        'operator': operator,
        'bookedForName': nameGuest,
        'bookedForNumber': phoneNumberGuest,
      };

      return await _dio.post(_path, data: data);
    } on DioException catch(e){
      return e.response;
    }
  }


  Future<Response?> deleteBookings({required String bookingId}) async {
    try {
      return await _dio.delete(
        _path,
        queryParameters: {
          'bookingId': bookingId
        }
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}