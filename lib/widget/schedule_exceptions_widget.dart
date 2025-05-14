import 'package:beauty_center_frontend/model/schedule_exceptions_dto.dart';
import 'package:flutter/material.dart';

import '../utils/date_util.dart';
import '../utils/strings.dart';

class ScheduleExceptionsWidget extends StatelessWidget {
  const ScheduleExceptionsWidget({
    super.key,
    required this.schedule
  });

  final ScheduleExceptionsDto schedule;


  @override
  Widget build(BuildContext context) {
    String dateText = "${schedule.startDate.day} ${DateUtil.getItalianMonthName(month: schedule.startDate.month)}";
    if(schedule.endDate != null) {
      dateText += " - ${schedule.endDate!.day} ${DateUtil.getItalianMonthName(month: schedule.endDate!.month)}";
    }

    String? morningStart = schedule.morningStart != null
        ? "${schedule.morningStart?.hour.toString().padLeft(2, '0')}:${schedule.morningStart?.minute.toString().padLeft(2, '0')}"
        : null;
    String? morningEnd = schedule.morningEnd != null
        ? "${schedule.morningEnd?.hour.toString().padLeft(2, '0')}:${schedule.morningEnd?.minute.toString().padLeft(2, '0')}"
        : null;

    String morning = (morningStart  != null && morningEnd != null) ? "$morningStart - $morningEnd" : Strings.free;

    String? afternoonStart = schedule.afternoonStart != null
        ? "${schedule.afternoonStart?.hour.toString().padLeft(2, '0')}:${schedule.afternoonStart?.minute.toString().padLeft(2, '0')}"
        : null;
    String? afternoonEnd = schedule.afternoonEnd != null
        ? "${schedule.afternoonEnd?.hour.toString().padLeft(2, '0')}:${schedule.afternoonEnd?.minute.toString().padLeft(2, '0')}"
        : null;

    String afternoon = (afternoonStart  != null && afternoonEnd != null) ? "$afternoonStart - $afternoonEnd" : Strings.free;


    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Text(
              dateText,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
          ),

          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.25).toInt()))
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        Strings.am,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary)
                    ),

                    Text(morning, style: Theme.of(context).textTheme.bodySmall),

                    Text(
                        Strings.pm,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary)
                    ),

                    Text(afternoon, style: Theme.of(context).textTheme.bodySmall),
                  ]
              )
          )
        ]
    );
  }
}
