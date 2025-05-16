
import 'package:beauty_center_frontend/api/schedule_exceptions_service.dart';
import 'package:beauty_center_frontend/model/schedule_exceptions_dto.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/SummaryOperatorDto.dart';
import '../utils/strings.dart';

part 'schedule_exception_provider.g.dart';

class ScheduleExceptionsProviderData {
  final List<ScheduleExceptionsDto> operatorScheduleException;
  final SummaryOperatorDto selectedOperator;

  ScheduleExceptionsProviderData({
    List<ScheduleExceptionsDto>? operatorScheduleException,
    SummaryOperatorDto? selectedOperator
  }) :  operatorScheduleException = operatorScheduleException ?? [],
        selectedOperator = selectedOperator ?? SummaryOperatorDto.empty();


  ScheduleExceptionsProviderData copyWith({
    List<ScheduleExceptionsDto>? operatorScheduleException,
    SummaryOperatorDto? selectedOperator
  }) {
    return ScheduleExceptionsProviderData(
      operatorScheduleException: operatorScheduleException ?? this.operatorScheduleException,
      selectedOperator: selectedOperator ?? this.selectedOperator
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


  Future<MapEntry<bool, String>> getOperatorSchedulesException() async {
    final response = await _scheduleExceptionsService.getScheduleSException(operatorId: state.selectedOperator.id);
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


  Future<MapEntry<bool, String>> deleteScheduleException({required String scheduleId}) async {
    final response = await _scheduleExceptionsService.deleteScheduleException(scheduleId: scheduleId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204) {
      List<ScheduleExceptionsDto> schedules = state.operatorScheduleException;
      schedules.removeWhere((schedule) => schedule.id == scheduleId);

      state = state.copyWith(operatorScheduleException: schedules);
      return MapEntry(true, Strings.schedule_deleted_correctly);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  void updateSelectedOperator({required SummaryOperatorDto operator}) {
    state = state.copyWith(selectedOperator: operator);
  }



  void reset() {
    state = state.copyWith(operatorScheduleException: []);
  }
}