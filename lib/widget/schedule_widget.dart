import 'package:beauty_center_frontend/model/day_of_week.dart';
import 'package:beauty_center_frontend/model/standard_schedule_dto.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/standard_schedule_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../utils/strings.dart';


class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    super.key,
    required this.schedule,
    this.day,
    required this.isNewSchedule,
    required this.operatorId
  });

  final StandardScheduleDto? schedule;
  final DayOfWeek? day;
  final bool isNewSchedule;
  final String operatorId;

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  bool _toggled = false;
  
  Widget _scheduleTimes({
    required StandardScheduleDto schedule,
    required BuildContext context,
  }){
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
              DayOfWeek.getItalianName(schedule.day.name),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
          ),

          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    transitionAnimationController: AnimationController(
                        vsync: Navigator.of(context),
                        duration: Duration(milliseconds: 750)
                    ),
                    builder: (context) {
                      return StandardScheduleModalBottomSheet(
                        day: schedule.day,
                        schedule: schedule,
                        isNewSchedule: widget.isNewSchedule,
                        operatorId: widget.operatorId,
                      );
                    }
                );
              },
              child: Container(
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
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.schedule == null) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: !_toggled
          ? FilledButton(
            onPressed: () => setState(() => _toggled = !_toggled),
            child: Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline_rounded),
                Text(DayOfWeek.getItalianName(widget.day!.name))
              ]
            )
          )
          : _scheduleTimes(
            schedule: StandardScheduleDto(id: "", day: widget.day!),
            context: context,
          )
        
      );
    }

    return _scheduleTimes(schedule: widget.schedule!, context: context);
  }
}

