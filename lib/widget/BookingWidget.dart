import 'package:flutter/material.dart';

import '../model/BookingDto.dart';
import '../utils/Strings.dart';

class BookingWidget extends StatelessWidget {
  const BookingWidget({
    super.key,
    required this.booking
  });

  final BookingDto booking;
  @override
  Widget build(BuildContext context) {
    final TextStyle? displayMedium = Theme.of(context).textTheme.displayMedium;
    final TextStyle? displaySmall = Theme.of(context).textTheme.displaySmall;
    final TextStyle? displayLarge = Theme.of(context).textTheme.displayLarge;

    final TextStyle lightDisplayMedium = displayMedium!.copyWith(color: displayMedium.color!.withOpacity(0.5));

    final Color lightSecondary = Theme.of(context).colorScheme.secondary.withOpacity(0.05);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: AssetImage('assets/images/login-image.jpeg'),    // todo mettere NetworkImage e prendere imgUrl del service
                  fit: BoxFit.cover
              )
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
                        Text(booking.service.name, style: displayLarge),
                        Text("15€", style: displayMedium)    // todo prendere il price, al momento aldo non lo passa nel dto
                      ]
                  ),

                  const SizedBox(height: 5),

                  // room + hours + duration
                  Row(
                      children: [
                        Text("${booking.room} ", style: displayMedium),
                        Text("${Strings.at} ", style: lightDisplayMedium),
                        Text("${booking.time.hour.toString().padLeft(2,"0")} ${booking.time.minute.toString().padLeft(2,"0")} ", style: displayMedium),
                        Text("(30 min)", style: lightDisplayMedium),    // todo prendere durata del servizio
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
                        Text("${booking.customer.name} ${booking.customer.surname}", style: displaySmall),

                        GestureDetector(
                          onTap: () {},   // todo
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
