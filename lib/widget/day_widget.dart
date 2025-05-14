import 'package:beauty_center_frontend/utils/date_util.dart';
import 'package:flutter/material.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({
    super.key,
    required this.isSelected,
    required this.date,
    required this.onTap
  });

  final bool isSelected;
  final DateTime date;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Color? background = isSelected ? Theme.of(context).colorScheme.primary.withAlpha((255 * 0.25).toInt()) : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: background
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(DateUtil.getItalianWeekDayNamePrefix(weekday: date.weekday)),

            const SizedBox(height: 10),

            Text("${date.day}"),
          ]
        )
      )
    );
  }
}
