import 'package:edone_customer/pages/custom_widgets/booking_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../providers/booking_provider.dart';
import '../utils/strings.dart';
import 'modal/confirm_modal.dart';

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
        children: [
          Column(
            spacing: 16,
            children: [
              const SizedBox(height: 32),
              Lottie.asset(
                  'assets/lottie/no_items.json',
                  height: 200
              ),
              const Text(Strings.noBookings)
            ]
          )
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
            key: Key(bookingId),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) => SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
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
            },
            onDismissed: (direction) async {
              await ref.read(bookingProvider.notifier).deleteBooking(booking.id);
            },
            background: Container(
              width: 44,
              height: 44,
              color: Colors.red,
              alignment: Alignment.centerRight,
              transformAlignment: Alignment.center,
              child: const Icon(Icons.delete_rounded),
            ),
            child: BookingItem(booking: booking),
          );
        },
      ),
    );
  }
}
