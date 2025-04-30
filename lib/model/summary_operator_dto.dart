class SummaryOperatorDto {
  final String id;
  final String name;
  final String surname;
  final String imgUrl;

  SummaryOperatorDto({
    required this.id,
    required this.name,
    required this.surname,
    required this.imgUrl,
  });

  factory SummaryOperatorDto.fromJson(Map<String, dynamic> json) {
    return SummaryOperatorDto(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      imgUrl: json['imgUrl'],
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

  SummaryOperatorDto copyWith({
    String? id,
    String? name,
    String? surname,
    String? imgUrl,
  }) {
    return SummaryOperatorDto(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }
}
