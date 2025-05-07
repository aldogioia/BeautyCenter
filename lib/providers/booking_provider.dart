import 'package:edone_customer/api/booking_service.dart';
import 'package:edone_customer/model/booking_dto.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/Strings.dart';
import '../utils/secure_storage.dart';

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
    final customerId = await SecureStorage.getUserId();
    final response = await _bookingService.getCustomerBookings(customerId!);

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

  Future<String> newBooking({
    required String? customerId,
    required String operatorId,
    required String serviceId,
    required String? nameGuest,
    required String? phoneNumberGuest,
    required DateTime date,
    required String time
  }) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await _bookingService.newBooking(
        customerId: customerId,
        operatorId: operatorId,
        serviceId: serviceId,
        nameGuest: nameGuest,
        phoneNumberGuest: phoneNumberGuest,
        date: formattedDate,
        time: time
    );

    if(response == null) return Strings.connectionError;

    if(response.statusCode == 201){
      state = state.copyWith(
          bookings: [
            ...state.bookings,
            BookingDto.fromJson(response.data)
          ]
      );
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }

  Future<String> deleteBooking(String bookingId) async {
    final response = await _bookingService.deleteBooking(bookingId);

    if(response == null) return Strings.connectionError;

    if(response.statusCode == 204){
      state = state.copyWith(
        bookings: state.bookings.where((booking) => booking.id != bookingId).toList()
      );

      return "";
    }

    return (response.data as Map<String, dynamic>)['message'];
  }
}