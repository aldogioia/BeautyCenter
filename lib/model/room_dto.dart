import 'summary_service_dto.dart';

class RoomDto {
  final String id;
  final String name;
  final List<SummaryServiceDto> services;

  RoomDto({
    required this.id,
    required this.name,
    required this.services,
  });

  RoomDto copyWith({
    String? id,
    String? name,
    List<SummaryServiceDto>? services,
  }) {
    return RoomDto(
      id: id ?? this.id,
      name: name ?? this.name,
      services: services ?? this.services,
    );
  }

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    return RoomDto(
      id: json['id'] as String,
      name: json['name'] as String,
      services: json['services'] != null
          ? ((json['services'] as List<dynamic>))
          .map((service) => SummaryServiceDto.fromJson(service as Map<String, dynamic>))
          .toList()
          : []
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}
