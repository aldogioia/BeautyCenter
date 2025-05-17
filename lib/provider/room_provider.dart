import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/room_service.dart';
import '../model/room_dto.dart';
import '../model/summary_service_dto.dart';
import '../utils/strings.dart';


part 'room_provider.g.dart';


class RoomProviderData {
  final List<RoomDto> rooms;

  RoomProviderData({List<RoomDto>? rooms}) : rooms = rooms ?? [];

  RoomProviderData copyWith({List<RoomDto>? rooms}) {
    return RoomProviderData(rooms: rooms ?? this.rooms);
  }
}


@Riverpod(keepAlive: true)
class Room extends _$Room {
  final RoomService _roomService = RoomService();

  @override
  RoomProviderData build(){
    ref.keepAlive();
    return RoomProviderData();
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


  Future<String> updateRoom({
    required String id,
    required List<SummaryServiceDto> services,
    required String name
  }) async {


    final response =  await _roomService.updateRoom(
      id: id,
      services: services.map((e) => e.id).toList(),
      name: name
    );

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 204) {
      state = state.copyWith(
        rooms: state.rooms.map((e) {
          if(e.id == id) {
            return RoomDto(id: id, name: name.isEmpty ? e.name : name, services: services);
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

      return MapEntry(true, Strings.room_create_successfully);
    }

    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);

  }


  Future<MapEntry<bool, String>> deleteRoom({required String roomId}) async {
    final response = await _roomService.deleteRoom(roomId: roomId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204){
      List<RoomDto> newList = List.from(state.rooms);
      newList.removeWhere((e) => e.id == roomId);

      // todo rimuovere le booking prenotate per quella stanza

      state = state.copyWith(
          rooms: newList
      );
      return MapEntry(true, Strings.room_delete_successfully);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  void removeServiceFromRoom({required String serviceId}) {
    state = state.copyWith(
      rooms: state.rooms.map((room) {
        final removedServices = room.services;
        removedServices.removeWhere((service) => service.id == serviceId);

        return room.copyWith(services: removedServices);
      }).toList()
    );
  }


  void reset() {
    state = state.copyWith(rooms: []);
  }
}