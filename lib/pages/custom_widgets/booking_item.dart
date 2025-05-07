import 'package:edone_customer/model/booking_dto.dart';
import 'package:edone_customer/utils/converter_month.dart';
import 'package:flutter/material.dart';

import '../../utils/Strings.dart';


class BookingItem extends StatelessWidget {
  final BookingDto booking;
  const BookingItem({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 25,
      children: [
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                booking.service.imgUrl,
                fit: BoxFit.cover,
                height: 80,
                width: 80,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey,
                    height: 80,
                    width: 80,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    height: 80,
                    width: 80,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.white54),
                  );
                },
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(booking.service.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text("${booking.service.price}€"),
                    ],
                  ),
                  Row(
                      children: [
                        Text("${booking.date.day} ${ConverterMonth.convertMonth(booking.date.month)}", style: Theme.of(context).textTheme.bodySmall),
                        Opacity(
                            opacity: 0.5,
                            child: Text(Strings.at, style: Theme.of(context).textTheme.bodySmall)
                        ),
                        Text(booking.time.substring(0,5), style: Theme.of(context).textTheme.bodySmall),
                      ]
                  ),
                  Divider(
                    thickness: 0.5,
                  ),
                  Text("${booking.operator.name} ${booking.operator.surname}"),
                ],
              )
            )
          ],
        )
      ],
    );
  }
}
