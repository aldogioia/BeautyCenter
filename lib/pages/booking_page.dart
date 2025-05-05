import 'package:edone_customer/pages/custom_widgets/booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/booking_provider.dart';
import '../utils/strings.dart';

class BookingPage extends ConsumerWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final bookings = bookingState.bookings;

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(bookingProvider.notifier).getAllBookings();
      },
      child: bookings.isEmpty ?
      ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text(Strings.noBookings)),
          ),
        ],
      ) :
      ListView.separated(
        itemCount: bookings.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                Strings.services,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }
          final booking = bookings[index - 1];
          return BookingItem(booking: booking);
        },
      ),
    );
  }
}
