import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/time_utils.dart';
import 'api_service.dart';

class ScheduleExceptionsService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/schedule-exception";

  Future<Response?> getScheduleSException({required String operatorId}) async {
    try {
      return await _dio.get(
          _path,
          queryParameters: {
            'operatorId' : operatorId,
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> createScheduleException({
    required DateTime startDate,
    required DateTime? endDate,
    required TimeOfDay? morningStart,
    required TimeOfDay? morningEnd,
    required TimeOfDay? afternoonStart,
    required TimeOfDay? afternoonEnd,
    required String operatorId
  }) async {
    try {
      final data = {
          'operatorId': operatorId,
          'startDate': startDate.toIso8601String().split('T').first,
          if(endDate != null) 'endDate': endDate.toIso8601String().split('T').first,
          if (morningStart != null) "morningStart": TimeUtils.formatTimeOfDay(morningStart),
          if (morningEnd != null) "morningEnd": TimeUtils.formatTimeOfDay(morningEnd),
          if (afternoonStart != null) "afternoonStart": TimeUtils.formatTimeOfDay(afternoonStart),
          if (afternoonEnd != null) "afternoonEnd": TimeUtils.formatTimeOfDay(afternoonEnd),
        };
      return await _dio.post(
          _path,
          data: data
      );
    } on DioException catch(e){
      return e.response;
    }
  }


  // todo delete schedule;
}