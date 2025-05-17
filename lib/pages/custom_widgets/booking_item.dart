import 'package:cached_network_image/cached_network_image.dart';
import 'package:edone_customer/model/booking_dto.dart';
import 'package:edone_customer/utils/converter_month.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/Strings.dart';


class BookingItem extends StatelessWidget {
  final BookingDto booking;
  const BookingItem({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: booking.service.imgUrl,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: const FaIcon(FontAwesomeIcons.solidFaceSadTear)
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    Text("${booking.operator.name} ${booking.operator.surname}"),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: booking.operator.imgUrl,
                        fit: BoxFit.cover,
                        height: 25,
                        width: 25,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          height: 25,
                          width: 25,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          height: 25,
                          width: 25,
                          alignment: Alignment.center,
                          child: const FaIcon(FontAwesomeIcons.solidFaceSadTear)
                        ),
                      ),
                    ),
                  ]
                )
              ],
            )
          )
        ),
      ],
    );
  }
}
