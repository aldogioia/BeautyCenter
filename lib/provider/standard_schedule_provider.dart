import 'package:beauty_center_frontend/api/standard_schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/day_of_week.dart';
import '../model/standard_schedule_dto.dart';
import '../utils/strings.dart';

part 'standard_schedule_provider.g.dart';

class StandardScheduleProviderData {
  final List<StandardScheduleDto> operatorStandardSchedules;

  StandardScheduleProviderData({List<StandardScheduleDto>? operatorStandardSchedules}) : operatorStandardSchedules = operatorStandardSchedules ?? [];

  StandardScheduleProviderData copyWith({List<StandardScheduleDto>? operatorStandardSchedules}){
    return StandardScheduleProviderData(
        operatorStandardSchedules: operatorStandardSchedules ?? this.operatorStandardSchedules
    );
  }
}

@riverpod
class StandardSchedule extends _$StandardSchedule {
  final StandardScheduleService _standardScheduleService = StandardScheduleService();

  @override
  StandardScheduleProviderData build(){
    ref.keepAlive();
    return StandardScheduleProviderData();
  }

  Future<MapEntry<bool, String>> getOperatorStandardSchedules({required String operatorId}) async {
    final response = await _standardScheduleService.getStandardSchedule(operatorId: operatorId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 200) {
      state = state.copyWith(operatorStandardSchedules: (response.data as List).map((e) => StandardScheduleDto.fromJson(e)).toList());
      return MapEntry(true, Strings.filter_set);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> createStandardSchedule({
    required DayOfWeek day,
    required TimeOfDay? morningStart,
    required TimeOfDay? morningEnd,
    required TimeOfDay? afternoonStart,
    required TimeOfDay? afternoonEnd,
    required String operatorId
  }) async {
    final response = await _standardScheduleService.createStandardSchedules(
      day: day,
      morningStart: morningStart,
      morningEnd: morningEnd,
      afternoonStart: afternoonStart,
      afternoonEnd: afternoonEnd,
      operatorId: operatorId
    );

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 201) {
      final newSchedule = StandardScheduleDto.fromJson(response.data);

      List<StandardScheduleDto> schedules = state.operatorStandardSchedules;
      schedules.add(newSchedule);

      state = state.copyWith(operatorStandardSchedules: schedules);
      return MapEntry(true, Strings.schedule_created_correctly);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> updateStandardSchedule({
    required String id,
    required TimeOfDay? morningStart,
    required TimeOfDay? morningEnd,
    required TimeOfDay? afternoonStart,
    required TimeOfDay? afternoonEnd,
    required String operatorId
  }) async {
    final response = await _standardScheduleService.updateStandardSchedules(
        id: id,
        morningStart: morningStart,
        morningEnd: morningEnd,
        afternoonStart: afternoonStart,
        afternoonEnd: afternoonEnd,
        operatorId: operatorId
    );

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204) {
      state = state.copyWith(
        operatorStandardSchedules: state.operatorStandardSchedules.map((e){
          if(e.id == id) {
            return StandardScheduleDto(
              id: id,
              day: e.day,
              morningStart: morningStart,
              morningEnd: morningEnd,
              afternoonStart: afternoonStart,
              afternoonEnd: afternoonEnd
            );
          }
          return e;
        }).toList()
      );

      return MapEntry(true, Strings.schedule_updated_correctly);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }

  void reset(){
    state = state.copyWith(operatorStandardSchedules: []);
  }
}