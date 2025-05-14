import 'package:flutter/material.dart';

import '../utils/time_utils.dart';
import 'day_of_week.dart';

class StandardScheduleDto {
  final String id;
  final DayOfWeek day;
  final TimeOfDay? morningStart;
  final TimeOfDay? morningEnd;
  final TimeOfDay? afternoonStart;
  final TimeOfDay? afternoonEnd;

  StandardScheduleDto({
    required this.id,
    required this.day,
    this.morningStart,
    this.morningEnd,
    this.afternoonStart,
    this.afternoonEnd,
  });


  factory StandardScheduleDto.fromJson(Map<String, dynamic> json) {
    return StandardScheduleDto(
      id: json['id'] as String,
      day: DayOfWeek.fromString(json['day']),
      morningStart: json['morningStart'] != null ? TimeUtils.timeOfDayFromString(json['morningStart']) : null,
      morningEnd: json['morningEnd'] != null ? TimeUtils.timeOfDayFromString(json['morningEnd']) : null,
      afternoonStart: json['afternoonStart'] != null ? TimeUtils.timeOfDayFromString(json['afternoonStart']) : null,
      afternoonEnd: json['afternoonEnd'] != null ? TimeUtils.timeOfDayFromString(json['afternoonEnd']) : null,
    );
  }

}
