import 'package:dio/dio.dart';

import '../model/UpdateRoomDto.dart';
import 'ApiService.dart';

class RoomService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/room";

  Future<Response?> getAllRooms() async {
    try {
      return await _dio.get("$_path/all");
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> updateRoom({required UpdateRoomDto updateRoomDto}) async {
    try {
      return await _dio.patch(_path, data: updateRoomDto.toJson());
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> createRoom({
    required String name,
    required List<String> services
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "services": services,
      });

      return await _dio.post(
          _path,
          data: formData,
          options: Options(headers: {"Content-Type": "multipart/form-data"})
      );
    } on DioException catch(e){
      return e.response;
    }
  }


  Future<Response?> deleteRoom({required String roomId}) async {
    try {
      return await _dio.delete(
          _path,
          queryParameters: {"roomId" : roomId}
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}