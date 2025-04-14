import 'package:beauty_center_frontend/api/booking_service.dart';
import 'package:beauty_center_frontend/model/BookingDto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/strings.dart';

part 'booking_provider.g.dart';

class BookingProviderData {
  final List<BookingDto> operatorBookings;

  BookingProviderData({List<BookingDto>? operatorBookings}) : operatorBookings = operatorBookings ?? [];

  factory BookingProviderData.empty() {
    return BookingProviderData();
  }

  BookingProviderData copyWith({List<BookingDto>? operatorBookings}){
     return BookingProviderData(
       operatorBookings: operatorBookings ?? this.operatorBookings
     );
  }
}

@riverpod
class Booking extends _$Booking {
  final BookingService _bookingService = BookingService();

  @override
  BookingProviderData build(){
    return BookingProviderData();
  }


  Future<MapEntry<bool, String>> getOperatorBookings({required String operatorId, required DateTime date}) async {
    final response = await _bookingService.getOperatorBookings(operatorId: operatorId, date: date);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 200) {
      state = state.copyWith(operatorBookings: (response.data as List).map((e) => BookingDto.fromJson(e)).toList());
      return MapEntry(true, Strings.filter_set);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }
}