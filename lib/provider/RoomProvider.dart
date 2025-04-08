import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/RoomService.dart';
import '../model/RoomDto.dart';
import '../model/SummaryServiceDto.dart';
import '../model/UpdateRoomDto.dart';
import '../utils/Strings.dart';


part 'RoomProvider.g.dart';


class RoomProviderData {
  final List<RoomDto> rooms;

  RoomProviderData({List<RoomDto>? rooms}) : rooms = rooms ?? [];

  factory RoomProviderData.empty() {
    return RoomProviderData(
        rooms: []
    );
  }

  RoomProviderData copyWith({List<RoomDto>? rooms}) {
    return RoomProviderData(rooms: rooms ?? this.rooms);
  }
}


@riverpod
class Room extends _$Room {
  final RoomService _roomService = RoomService();

  @override
  RoomProviderData build(){
    return RoomProviderData.empty();
  }

  Future<String> getAllRooms() async {
    final response = await _roomService.getAllRooms();
    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200){
      state = state.copyWith(
          rooms: (response.data as List).map((json) => RoomDto.fromJson(json)).toList()
      );
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }


  Future<String> updateRoom({required RoomDto roomDto}) async {
    // todo rimuovere il dto, non serve
    final updateRoomDto = UpdateRoomDto(
        id: roomDto.id,
        services: roomDto.services.map((e) => e.id).toList()
    );

    final response =  await _roomService.updateRoom(updateRoomDto: updateRoomDto);

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 204) {
      state = state.copyWith(
        rooms: state.rooms.map((e) {
          if(e.id == roomDto.id) {
            return roomDto;
          }
          return e;
        }).toList()
      );
      return Strings.room_updated_successfully;
    }
    return (response.data as Map<String, dynamic>)['message'];
  }


  Future<MapEntry<bool,String>> createRoom({
    required String name,
    required List<SummaryServiceDto> services
  }) async {
    final response = await _roomService.createRoom(
      name: name,
      services: services.map((e) => e.id).toList()
    );

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 201){
      final List<RoomDto> newList = List.from(state.rooms);
      newList.add(RoomDto.fromJson(response.data));

      state = state.copyWith(rooms: newList);

      return MapEntry(true, Strings.operator_create_successfully);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> deleteRoom({required String roomId}) async {
    final response = await _roomService.deleteRoom(roomId: roomId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204){
      List<RoomDto> newList = List.from(state.rooms);
      newList.removeWhere((e) => e.id == roomId);

      state = state.copyWith(
          rooms: newList
      );
      return MapEntry(true, Strings.room_delete_successfully);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }
}