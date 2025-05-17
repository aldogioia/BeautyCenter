import 'summary_service_dto.dart';

class OperatorDto {
  final String id;
  final String name;
  final String surname;
  final String phoneNumber;
  final String imgUrl;
  final List<SummaryServiceDto> services;

  OperatorDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.imgUrl,
    required this.services
  });

  factory OperatorDto.empty(){
    return OperatorDto(
      id: "",
      name: "",
      surname: "",
      phoneNumber: "",
      imgUrl: "",
      services: []
    );
  }

  OperatorDto copyWith({
    String? id,
    String? name,
    String? surname,
    String? phoneNumber,
    String? imgUrl,
    List<SummaryServiceDto>? services
  }) {
    return OperatorDto(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imgUrl: imgUrl ?? this.imgUrl,
      services: services ?? this.services
    );
  }

  factory OperatorDto.fromJson(Map<String, dynamic> json){
    return OperatorDto(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      phoneNumber: json['phoneNumber'] as String,
      imgUrl: json['imgUrl'] as String,
      services: json['services'] != null
          ? (json['services'] as List<dynamic>)
          .map((e) => SummaryServiceDto.fromJson(e as Map<String, dynamic>))
          .toList()
          :[]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'imgUrl': imgUrl,
      'services': services.map((s) => s.toJson()).toList(),
    };
  }
}