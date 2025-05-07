import 'package:edone_customer/model/service_dto.dart';

import 'summary_customer_dto.dart';
import 'summary_operator_dto.dart';

class BookingDto {
  final String id;
  final ServiceDto service;
  final SummaryOperatorDto operator;
  final SummaryCustomerDto customer;
  final String room;
  final String? nameGuest;
  final String? phoneNumberGuest;
  final DateTime date;
  final String time;

  BookingDto({
    required this.id,
    required this.service,
    required this.operator,
    required this.customer,
    required this.room,
    this.nameGuest,
    this.phoneNumberGuest,
    required this.date,
    required this.time,
  });

  factory BookingDto.fromJson(Map<String, dynamic> json) {
    return BookingDto(
      id: json['id'],
      service: ServiceDto.fromJson(json['service']),
      operator: SummaryOperatorDto.fromJson(json['operator']),
      customer: SummaryCustomerDto.fromJson(json['bookedForCustomer']),
      nameGuest: json['bookedForName'],
      phoneNumberGuest: json['bookedForNumber'],
      room: json['room'],
      date: DateTime.parse(json['date']),
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service.toJson(),
      'operator': operator.toJson(),
      'bookedForCustomer': customer.toJson(),
      'room': room,
      'bookedForName': nameGuest,
      'bookedForNumber': phoneNumberGuest,
      'date': date.toIso8601String(),
      'time': time,
    };
  }

  BookingDto copyWith({
    String? id,
    ServiceDto? service,
    SummaryOperatorDto? operator,
    SummaryCustomerDto? customer,
    String? room,
    String? nameGuest,
    String? phoneNumberGuest,
    DateTime? date,
    String? time,
  }) {
    return BookingDto(
      id: id ?? this.id,
      service: service ?? this.service,
      operator: operator ?? this.operator,
      customer: customer ?? this.customer,
      room: room ?? this.room,
      nameGuest: nameGuest ?? this.nameGuest,
      phoneNumberGuest: phoneNumberGuest ?? this.phoneNumberGuest,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}
