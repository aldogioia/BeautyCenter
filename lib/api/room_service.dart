import 'package:dio/dio.dart';

import '../model/SummaryServiceDto.dart';
import 'api_service.dart';

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

  Future<Response?> updateRoom({
    required String id,
    required List<String> services,
    required String name
  }) async {
    try {
      final data = {
        'id': id,
        'services': services,
        'name': name
      };

      return await _dio.put(_path, data: data);
    } on DioException catch(e){
      return e.response;
    }
  }

  Future<Response?> createRoom({
    required String name,
    required List<String> services
  }) async {
    try {
      return await _dio.post(
          _path,
          data: {
            "name": name,
            "services": services
          }
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