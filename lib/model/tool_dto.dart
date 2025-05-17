class ToolDto {
  final String id;
  final String name;
  final int availability;

  ToolDto({required this.id, required this.name, required this.availability});

  ToolDto copyWith({String? id, String? name, int? availability}){
    return ToolDto(
      id: id ?? this.id,
      name: name ?? this.name,
      availability: availability ?? this.availability
    );
  }

  factory ToolDto.fromJson({required Map<String, dynamic> json}) {
    return ToolDto(
      id: json['id'],
      name: json['name'],
      availability: (json['availability'] as num).toInt()
    );
  }
}