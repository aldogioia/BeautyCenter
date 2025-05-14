
import 'package:beauty_center_frontend/api/schedule_exceptions_service.dart';
import 'package:beauty_center_frontend/model/schedule_exceptions_dto.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/strings.dart';

part 'schedule_exception_provider.g.dart';

class ScheduleExceptionsProviderData {
  final List<ScheduleExceptionsDto> operatorScheduleException;

  ScheduleExceptionsProviderData({List<ScheduleExceptionsDto>? operatorScheduleException}) : operatorScheduleException = operatorScheduleException ?? [];

  ScheduleExceptionsProviderData copyWith({List<ScheduleExceptionsDto>? operatorScheduleException}) {
    return ScheduleExceptionsProviderData(
      operatorScheduleException: operatorScheduleException ?? this.operatorScheduleException
    );
  }
}


@riverpod
class ScheduleException extends _$ScheduleException {
  final ScheduleExceptionsService _scheduleExceptionsService = ScheduleExceptionsService();

  @override
  ScheduleExceptionsProviderData build(){
    ref.keepAlive();
    return ScheduleExceptionsProviderData();
  }


  Future<MapEntry<bool, String>> getOperatorSchedulesException({required String operatorId}) async {
    final response = await _scheduleExceptionsService.getScheduleSException(operatorId: operatorId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 200) {
      state = state.copyWith(operatorScheduleException: (response.data as List).map((e) => ScheduleExceptionsDto.fromJson(e)).toList());
      return MapEntry(true, Strings.filter_set);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> createScheduleException({
    required DateTime startDate,
    required DateTime? endDate,
    required TimeOfDay? morningStart,
    required TimeOfDay? morningEnd,
    required TimeOfDay? afternoonStart,
    required TimeOfDay? afternoonEnd,
    required String operatorId
  }) async {
    final response = await _scheduleExceptionsService.createScheduleException(
        morningStart: morningStart,
        morningEnd: morningEnd,
        afternoonStart: afternoonStart,
        afternoonEnd: afternoonEnd,
        operatorId: operatorId,
        startDate: startDate,
        endDate: endDate
    );

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 201) {
      final newSchedule = ScheduleExceptionsDto.fromJson(response.data);

      List<ScheduleExceptionsDto> schedules = state.operatorScheduleException;
      schedules.add(newSchedule);

      state = state.copyWith(operatorScheduleException: schedules);
      return MapEntry(true, Strings.schedule_created_correctly);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }

  void reset() {
    state = state.copyWith(operatorScheduleException: []);
  }
}