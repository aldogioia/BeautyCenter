import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../handler/snack_bar_handler.dart';
import '../model/BookingDto.dart';
import '../utils/strings.dart';

class BookingWidget extends StatelessWidget {
  const BookingWidget({
    super.key,
    required this.booking
  });

  final BookingDto booking;


  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      SnackBarHandler.instance.showMessage(message: Strings.cannot_do_phone_call);
    }
  }


  @override
  Widget build(BuildContext context) {
    final Color lightSecondary = Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.05).toInt());
    String name = booking.customer != null ? "${booking.customer!.name} ${booking.customer!.surname}" : booking.bookedForName!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Image.network(
                      booking.service.imgUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey,
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                            color: Colors.grey,
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported)
                        );
                      },
                    ),
                  ]
              )
          ),

          const SizedBox(width: 10),

          Flexible(
            child: Column(
                children: [
                  // service name + price
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(booking.service.name, style: Theme.of(context).textTheme.bodyLarge),
                        Text("${booking.service.price} €")
                      ]
                  ),

                  const SizedBox(height: 5),

                  // room + hours + duration
                  Row(
                      children: [
                        Text("${booking.room} "),
                        Text("${Strings.at} ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.6).toInt())),),
                        Text("${booking.time.hour.toString().padLeft(2,"0")} ${booking.time.minute.toString().padLeft(2,"0")} "),
                        Text("(${booking.service.duration} min)"),
                      ]
                  ),

                  const SizedBox(height: 5),

                  Container(height: 1, color: lightSecondary),

                  const SizedBox(height: 5),

                  // Customer name + surname + phone icon
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.bodySmall),

                      GestureDetector(
                        // todo vedere se va bene mettere +39 in questo modo
                        onTap: () async => await _makePhoneCall(booking.customer != null ? "+39${booking.customer!.phoneNumber}" : "+39${booking.bookedForNumber}"),
                        child: Icon(Icons.phone_outlined, color: Theme.of(context).colorScheme.primary, size: 16),
                      )
                    ]
                  )
                ]
            )
          )
        ]
      )
    );
  }
}
