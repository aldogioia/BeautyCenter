import 'SummaryServiceDto.dart';

class OperatorDto {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String imgUrl;
  final List<SummaryServiceDto> services;

  OperatorDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.imgUrl,
    required this.services
  });

  factory OperatorDto.empty(){
    return OperatorDto(
      id: "",
      name: "",
      surname: "",
      email: "",
      imgUrl: "",
      services: []
    );
  }

  OperatorDto copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    String? imgUrl,
    List<SummaryServiceDto>? services
  }) {
    return OperatorDto(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      imgUrl: imgUrl ?? this.imgUrl,
      services: services ?? this.services
    );
  }

  factory OperatorDto.fromJson(Map<String, dynamic> json){
    return OperatorDto(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      imgUrl: json['imgUrl'] as String,
      services: (json['services'] as List<dynamic>)
          .map((e) => SummaryServiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'imgUrl': imgUrl,
      'services': services.map((s) => s.toJson()).toList(),
    };
  }
}