import 'package:edone_customer/pages/custom_widgets/booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/booking_provider.dart';
import '../utils/strings.dart';
import 'custom_widgets/confirm_modal.dart';

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
            return SizedBox(height: 32);
          }
          final booking = bookings[index - 1];
          final bookingId = booking.id;

          return Dismissible(
            key: Key(bookingId.toString()),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              final shouldDelete = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConfirmModal(
                    text1: "Si, disdici la prenotazione",
                    text2: 'No, mantieni la prenotazione',
                    icon: Icons.delete,
                    onConfirm: () {
                      Navigator.of(context).pop(true);
                    },
                    onCancel: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                )
              );

              if (shouldDelete == true) {
                await ref.read(bookingProvider.notifier).deleteBooking(booking.id);
                return true;
              }
              return false;
            },
            background: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_rounded),
                ),
              ),
            ),
            child: BookingItem(booking: booking),
          );
        },
      ),
    );
  }
}
