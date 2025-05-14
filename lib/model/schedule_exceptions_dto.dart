import 'package:flutter/material.dart';

import '../utils/time_utils.dart';
import 'day_of_week.dart';

class ScheduleExceptionsDto {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final TimeOfDay? morningStart;
  final TimeOfDay? morningEnd;
  final TimeOfDay? afternoonStart;
  final TimeOfDay? afternoonEnd;

  ScheduleExceptionsDto({
    required this.id,
    required this.startDate,
    this.endDate,
    this.morningStart,
    this.morningEnd,
    this.afternoonStart,
    this.afternoonEnd,
  });


  factory ScheduleExceptionsDto.fromJson(Map<String, dynamic> json) {
    return ScheduleExceptionsDto(
      id: json['id'] as String,
      morningStart: json['morningStart'] != null ? TimeUtils.timeOfDayFromString(json['morningStart']) : null,
      morningEnd: json['morningEnd'] != null ? TimeUtils.timeOfDayFromString(json['morningEnd']) : null,
      afternoonStart: json['afternoonStart'] != null ? TimeUtils.timeOfDayFromString(json['afternoonStart']) : null,
      afternoonEnd: json['afternoonEnd'] != null ? TimeUtils.timeOfDayFromString(json['afternoonEnd']) : null,
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null
    );
  }

}