import 'SummaryCustomerDto.dart';
import 'SummaryOperatorDto.dart';
import 'SummaryServiceDto.dart';

class BookingDto {
  final String id;
  final SummaryServiceDto service;
  final SummaryOperatorDto operator;
  final SummaryCustomerDto customer;
  final String room;
  final DateTime date;
  final DateTime time;

  BookingDto({
    required this.id,
    required this.service,
    required this.operator,
    required this.customer,
    required this.room,
    required this.date,
    required this.time,
  });

  factory BookingDto.fromJson(Map<String, dynamic> json) {
    return BookingDto(
      id: json['id'],
      service: SummaryServiceDto.fromJson(json['service']),
      operator: SummaryOperatorDto.fromJson(json['operator']),
      customer: SummaryCustomerDto.fromJson(json['customer']),
      room: json['room'],
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service.toJson(),
      'operator': operator.toJson(),
      'customer': customer.toJson(),
      'room': room,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
    };
  }

  BookingDto copyWith({
    String? id,
    SummaryServiceDto? service,
    SummaryOperatorDto? operator,
    SummaryCustomerDto? customer,
    String? room,
    DateTime? date,
    DateTime? time,
  }) {
    return BookingDto(
      id: id ?? this.id,
      service: service ?? this.service,
      operator: operator ?? this.operator,
      customer: customer ?? this.customer,
      room: room ?? this.room,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}
