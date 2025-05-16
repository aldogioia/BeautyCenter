  import 'package:beauty_center_frontend/api/booking_service.dart';
import 'package:beauty_center_frontend/model/BookingDto.dart';
import 'package:beauty_center_frontend/model/SummaryOperatorDto.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/strings.dart';

part 'booking_provider.g.dart';

class BookingProviderData {
  final List<BookingDto> operatorBookings;
  final SummaryOperatorDto selectedOperator;

  BookingProviderData({
    List<BookingDto>? operatorBookings,
    SummaryOperatorDto? selectedOperator
  }) : operatorBookings = operatorBookings ?? [],
        selectedOperator = selectedOperator ?? SummaryOperatorDto.empty();


  BookingProviderData copyWith({
    List<BookingDto>? operatorBookings,
    SummaryOperatorDto? selectedOperator
  }){
     return BookingProviderData(
       operatorBookings: operatorBookings ?? this.operatorBookings,
       selectedOperator: selectedOperator ?? this.selectedOperator
     );
  }
}


@Riverpod(keepAlive: true)
class Booking extends _$Booking {
  final BookingService _bookingService = BookingService();

  @override
  BookingProviderData build(){
    return BookingProviderData();
  }


  Future<MapEntry<bool, String>> getOperatorBookings({required DateTime date}) async {
    final response = await _bookingService.getOperatorBookings(operatorId: state.selectedOperator.id, date: date);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 200) {
      state = state.copyWith(operatorBookings: (response.data as List).map((e) => BookingDto.fromJson(e)).toList());
      return MapEntry(true, Strings.filter_set);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> createBookings({
    required DateTime date,
    required TimeOfDay time,
    required String service,
    required String operator,
    String? nameGuest,
    String? phoneNumberGuest
  }) async {
    final response = await _bookingService.createBooking(
      date: date,
      time: time,
      service: service,
      operator: operator,
      nameGuest: nameGuest,
      phoneNumberGuest: phoneNumberGuest
    );

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 201) {
      // todo controllo se l'operatore selezionato e uguale all'operatore con il quale si sta creando la booking
      return MapEntry(true, Strings.booking_created_successfully);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> deleteBooking({required String bookingId}) async {
    final response = await _bookingService.deleteBookings(bookingId: bookingId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204) {
      final removedBookings = state.operatorBookings;
      removedBookings.removeWhere((booking) => booking.id == bookingId);
      state = state.copyWith(operatorBookings: removedBookings);

      return MapEntry(true, Strings.booking_deleted);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  void updateSelectedOperator({required SummaryOperatorDto operator}) {
    state = state.copyWith(selectedOperator: operator);
  }


  void reset() {
    state = state.copyWith(operatorBookings: [], selectedOperator: SummaryOperatorDto.empty());
  }
}