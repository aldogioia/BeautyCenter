import 'package:edone_customer/pages/custom_widgets/booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/booking_provider.dart';
import '../utils/strings.dart';

class BookingPage extends ConsumerWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingProvider).bookings;

    if (bookings.isEmpty) {
      return const Center(child: Text(Strings.noServices));
    }

    return ListView.separated(
      itemCount: bookings.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(Strings.bookings, style: TextStyle(fontWeight: FontWeight.bold));
        }
        final booking = bookings[index - 1];
        return BookingItem(booking: booking);
      },
    );
  }
}