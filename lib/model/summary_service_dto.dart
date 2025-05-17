class SummaryServiceDto {
  final String id;
  final String name;

  SummaryServiceDto({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SummaryServiceDto &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  SummaryServiceDto copyWith({
    String? id,
    String? name,
  }) {
    return SummaryServiceDto(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory SummaryServiceDto.fromJson(Map<String, dynamic> json) {
    return SummaryServiceDto(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
