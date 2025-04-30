import 'summary_service_dto.dart';

class OperatorDto {
  final String id;
  final String name;
  final String surname;
  final String imgUrl;

  OperatorDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.imgUrl
  });

  factory OperatorDto.empty(){
    return OperatorDto(
      id: "",
      name: "",
      surname: "",
      imgUrl: "",
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
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  factory OperatorDto.fromJson(Map<String, dynamic> json){
    return OperatorDto(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      imgUrl: json['imgUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'imgUrl': imgUrl,
    };
  }
}