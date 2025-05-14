class ServiceDto {
  final String id;
  final String name;
  final double price;
  final int duration;
  final String imgUrl;

  ServiceDto({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.imgUrl
  });

  ServiceDto copyWith({
    String? id,
    String? name,
    double? price,
    int? duration,
    String? imgUrl
  }) {
    return ServiceDto(
      imgUrl: imgUrl ?? this.imgUrl,
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
    );
  }

  factory ServiceDto.fromJson(Map<String, dynamic> json) {
    return ServiceDto(
      imgUrl: json['imgUrl'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      duration: (json['duration'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imgUrl': imgUrl,
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
    };
  }
}