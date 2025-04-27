import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  List<String> bookings = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 25,
      children: [
        Text(
          Strings.bookings,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                Image.asset(
                  'assets/images/img.jpg',
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                )
            ),
            Flexible(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Unghie", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Text("15,00€"),
                  ],
                ),
                Row(
                  children: [
                    Text("20 Aprile", style: Theme.of(context).textTheme.bodySmall),
                    Opacity(
                        opacity: 0.5,
                        child: Text(Strings.at, style: Theme.of(context).textTheme.bodySmall)
                    ),
                    Text("10:00", style: Theme.of(context).textTheme.bodySmall),
                  ]
                ),
                Divider(
                  thickness: 0.5,
                ),
                Text("Aldo Gioia")
              ],
            )
            )
          ],
        )
      ],
    );
  }
}