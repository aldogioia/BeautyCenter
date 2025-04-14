import 'package:dio/dio.dart';

import 'api_service.dart';

class BookingService {
  final Dio _dio = ApiService.instance.dio;
  final String _path = "/booking";

  Future<Response?> getOperatorBookings({required String operatorId, required DateTime date}) async {
    try {
      return await _dio.get(
          _path,
          queryParameters: {
            'operatorId' : operatorId,
            'date' : date
          }
      );
    } on DioException catch(e){
      return e.response;
    }
  }
}