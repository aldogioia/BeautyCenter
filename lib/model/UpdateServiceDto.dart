import 'dart:io';

// todo rimuovere

class UpdateServiceDto {
  final String id;
  final File? image;
  final String name;
  final double price;
  final int duration;

  UpdateServiceDto({
    required this.id,
    this.image,
    required this.name,
    required this.price,
    required this.duration,
  });

  UpdateServiceDto copyWith({
    String? id,
    File? image,
    String? name,
    double? price,
    int? duration,
  }) {
    return UpdateServiceDto(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
    );
  }
}