import 'package:edone_customer/api/booking_service.dart';
import 'package:edone_customer/model/booking_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/Strings.dart';

part 'booking_provider.g.dart';

class BookingProviderState{
  List<BookingDto> bookings;

  BookingProviderState({
    List<BookingDto>? bookings
  }) : bookings = bookings ?? [];

  factory BookingProviderState.empty() {
    return BookingProviderState(
        bookings: []
    );
  }

  BookingProviderState copyWith({List<BookingDto>? bookings}) {
    return BookingProviderState(bookings: bookings ?? this.bookings);
  }
}

@riverpod
class Booking extends _$Booking {
  final BookingService _bookingService = BookingService();

  @override
  BookingProviderState build(){
    ref.keepAlive();
    return BookingProviderState.empty();
  }

  Future<String> getAllBookings() async {
    final response = await _bookingService.getCustomerBookings(customerId: ""); //TODO: capire come ottenere l'id del cliente

    if(response == null) return Strings.connectionError;

    if(response.statusCode == 200){
      if(response.data.isEmpty) return Strings.noBookings;

      state = state.copyWith(
          bookings: (response.data as List).map((json) => BookingDto.fromJson(json)).toList()
      );
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }
}