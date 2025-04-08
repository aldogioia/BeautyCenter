import 'package:beauty_center_frontend/model/UpdateCustomerDto.dart';

// todo rimuovere
class UpdateRoomDto {
  final String id;
  final List<String> services;

  UpdateRoomDto({required this.id, required this.services});

  UpdateRoomDto copyWith({String? id, List<String>? services}){
    return UpdateRoomDto(
      id: id ?? this.id,
      services: services ?? this.services
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'services': services
    };
  }
}