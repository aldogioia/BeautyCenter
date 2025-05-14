import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/day_of_week.dart';
import '../utils/time_utils.dart';
import 'api_service.dart';

class StandardScheduleService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/standard-schedule";

  Future<Response?> getStandardSchedule({required String operatorId}) async {
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

  Future<Response?> createStandardSchedules({
    required DayOfWeek day,
    required TimeOfDay? morningStart,
    required TimeOfDay? morningEnd,
    required TimeOfDay? afternoonStart,
    required TimeOfDay? afternoonEnd,
    required String operatorId
  }) async {
    try {
      final data = {
          'day': day.name.toUpperCase(),
          'operatorId': operatorId,
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

  Future<Response?> updateStandardSchedules({
    required String id,
    required TimeOfDay? morningStart,
    required TimeOfDay? morningEnd,
    required TimeOfDay? afternoonStart,
    required TimeOfDay? afternoonEnd,
    required String operatorId
  }) async {
    try {
      final data = {
          'id': id,
          'operatorId': operatorId,
          if (morningStart != null) "morningStart": TimeUtils.formatTimeOfDay(morningStart),
          if (morningEnd != null) "morningEnd": TimeUtils.formatTimeOfDay(morningEnd),
          if (afternoonStart != null) "afternoonStart": TimeUtils.formatTimeOfDay(afternoonStart),
          if (afternoonEnd != null) "afternoonEnd": TimeUtils.formatTimeOfDay(afternoonEnd),
        };
      return await _dio.patch(
          _path,
          data: data
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}