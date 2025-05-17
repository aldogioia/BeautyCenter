import 'package:beauty_center_frontend/model/summary_tool_dto.dart';

class ServiceDto {
  final String id;
  final String name;
  final double price;
  final int duration;
  final String imgUrl;
  final List<SummaryToolDto> tools;

  ServiceDto({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.imgUrl,
    required this.tools
  });

  ServiceDto copyWith({
    String? id,
    String? name,
    double? price,
    int? duration,
    String? imgUrl,
    List<SummaryToolDto>? tools
  }) {
    return ServiceDto(
      imgUrl: imgUrl ?? this.imgUrl,
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      tools: tools ?? this.tools,
    );
  }

  factory ServiceDto.fromJson(Map<String, dynamic> json) {
    return ServiceDto(
      imgUrl: json['imgUrl'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      duration: (json['duration'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      tools:  json['tools'] != null
          ? ((json['tools'] as List<dynamic>))
          .map((json) => SummaryToolDto.fromJson(json: json))
          .toList()
          : [],
    );
  }

}