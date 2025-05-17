import 'package:flutter/material.dart';

import '../utils/time_utils.dart';
import 'ServiceDto.dart';
import 'summary_customer_dto.dart';
import 'summary_operator_dto.dart';

class BookingDto {
  final String id;
  final ServiceDto service;
  final SummaryOperatorDto operator;
  final SummaryCustomerDto? customer;
  final String room;
  final DateTime date;
  final TimeOfDay time;
  final String? bookedForName;
  final String? bookedForNumber;

  BookingDto({
    required this.id,
    required this.service,
    required this.operator,
    required this.customer,
    required this.room,
    required this.date,
    required this.time,
    required this.bookedForName,
    required this.bookedForNumber
  });

  factory BookingDto.fromJson(Map<String, dynamic> json) {
    return BookingDto(
      id: json['id'],
      service: ServiceDto.fromJson(json['service']),
      operator: SummaryOperatorDto.fromJson(json['operator']),
      customer: json['bookedForCustomer'] == null ? null : SummaryCustomerDto.fromJson(json['bookedForCustomer']),
      room: json['room'],
      date: DateTime.parse(json['date']),
      time: TimeUtils.timeOfDayFromString(json['time']),
      bookedForName: json['bookedForName'],
      bookedForNumber: json['bookedForNumber'],
    );
  }

  BookingDto copyWith({
    String? id,
    ServiceDto? service,
    SummaryOperatorDto? operator,
    SummaryCustomerDto? customer,
    String? room,
    DateTime? date,
    TimeOfDay? time,
    String? bookedForName,
    String? bookedForNumber
  }) {
    return BookingDto(
      id: id ?? this.id,
      service: service ?? this.service,
      operator: operator ?? this.operator,
      customer: customer ?? this.customer,
      room: room ?? this.room,
      date: date ?? this.date,
      time: time ?? this.time,
      bookedForName: bookedForName ?? this.bookedForName,
      bookedForNumber: bookedForNumber ?? this.bookedForNumber
    );
  }
}
