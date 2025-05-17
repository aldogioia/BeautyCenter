class SummaryToolDto {
  final String id;
  final String name;

  SummaryToolDto({required this.id, required this.name});

  SummaryToolDto copyWith({String? id, String? name}) {
    return SummaryToolDto(
      id: id ?? this.id,
      name: name ?? this.name
    );
  }

  factory SummaryToolDto.fromJson({required Map<String, dynamic> json}){
    return SummaryToolDto(
      id: json['id'],
      name: json['name']
    );
  }

}