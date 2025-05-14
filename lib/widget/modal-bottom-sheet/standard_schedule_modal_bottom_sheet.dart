import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/model/day_of_week.dart';
import 'package:beauty_center_frontend/provider/standard_schedule_provider.dart';
import 'package:beauty_center_frontend/security/input_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/standard_schedule_dto.dart';
import '../../utils/strings.dart';

class StandardScheduleModalBottomSheet extends ConsumerStatefulWidget {
  const StandardScheduleModalBottomSheet({
    super.key,
    required this.schedule,
    required this.day,
    required this.isNewSchedule,
    required this.operatorId
  });

  final DayOfWeek day;
  final StandardScheduleDto schedule;
  final bool isNewSchedule;
  final String operatorId;

  @override
  ConsumerState<StandardScheduleModalBottomSheet> createState() => _StandardScheduleModalBottomSheetState();
}

class _StandardScheduleModalBottomSheetState extends ConsumerState<StandardScheduleModalBottomSheet> {
  late List<TimeOfDay> _times;


  TimeOfDay? _morningStartTime;
  TimeOfDay? _morningEndTime;
  TimeOfDay? _afternoonStartTime;
  TimeOfDay? _afternoonEndTime;
  late bool _isFreeMorning;
  late bool _isFreeAfternoon;

  Widget _buildTime({required String time, required void Function(TimeOfDay?) onSelected, required TimeOfDay? startTime}){
    int index = _times.indexWhere((t) => t.hour == startTime?.hour && t.minute == startTime?.minute);
    final controller = FixedExtentScrollController(initialItem: index >= 0 ? index : 0);

    return PopupMenuButton(
      itemBuilder: (context){
        return [
          PopupMenuItem(
            child: _buildCupertinoPicker(
              startValue: startTime,
              controller: controller,
              onTap: (time) => onSelected(time)
            )
          )
        ];
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        width: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.25).toInt()))
        ),
        child: Text(time),
      ),
    );
  }


  List<TimeOfDay> _generateTimeList() {
    final List<TimeOfDay> list = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        list.add(TimeOfDay(hour: hour, minute: minute));
      }
    }
    return list;
  }


  Widget _buildCupertinoPicker({
    required TimeOfDay? startValue,
    required FixedExtentScrollController controller,
    required void Function(TimeOfDay?) onTap
  }) {
    TimeOfDay? time = startValue;

    return Center(
      child: Column(
        spacing: 8,
        children: [
          SizedBox(
              height: 130,
              width: 150,
              child: CupertinoPicker(
                  scrollController: controller,
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    time = _times[index];
                  },
                  selectionOverlay:  Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.25).toInt()),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  children: _times.map((time) {
                    return Center(
                        child: Text(
                          "${time.hour.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')}",
                          style: Theme.of(context).textTheme.labelMedium,
                        )
                    );
                  }).toList()
              )
          ),

          GestureDetector(
              onTap: () {
                onTap(time);
                Navigator.of(context).pop();
              },
              child: Text(
                Strings.select,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )
          )

        ]
      )
    );
  }

  Future<void> _save() async {
    // todo controllare con aldo se vanno bene le validazioni
    String message = "";
    if(!InputValidator.validateStartAndEndScheduleTime(start: _morningStartTime, end: _morningEndTime) ||
        !InputValidator.validateStartAndEndScheduleTime(start: _afternoonStartTime, end: _afternoonEndTime)
    ){
      message = Strings.start_and_end_times_error;
    } else if(_afternoonStartTime != null && _morningEndTime != null && _afternoonStartTime!.isBefore(_morningEndTime!)){
      message = Strings.afternoon_schedule_before_morning_schedule_error;
    } else {
      final navigator = Navigator.of(context);
      MapEntry<bool, String> result;

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      );


      if(widget.isNewSchedule){
        result = await ref.read(standardScheduleProvider.notifier).createStandardSchedule(
            day: widget.schedule.day,
            morningStart: _morningStartTime,
            morningEnd: _morningEndTime,
            afternoonStart: _afternoonStartTime,
            afternoonEnd: _afternoonEndTime,
            operatorId: widget.operatorId
        );
      } else {
        result = await ref.read(standardScheduleProvider.notifier).updateStandardSchedule(
          id: widget.schedule.id,
          morningStart: _morningStartTime,
          morningEnd: _morningEndTime,
          afternoonStart: _afternoonStartTime,
          afternoonEnd: _afternoonEndTime,
          operatorId: widget.operatorId
        );
      }


      navigator.pop();

      message = result.value;
      if(result.key) navigator.pop();
    }
    SnackBarHandler.instance.showMessage(message: message);
  }

  @override
  void initState() {
    super.initState();
    _isFreeMorning = widget.schedule.morningStart == null && widget.schedule.morningEnd == null;
    _isFreeAfternoon = widget.schedule.afternoonStart == null && widget.schedule.afternoonEnd == null;
    _morningStartTime = widget.schedule.morningStart;
    _morningEndTime = widget.schedule.morningEnd;
    _afternoonStartTime = widget.schedule.afternoonStart;
    _afternoonEndTime = widget.schedule.afternoonEnd;

    _times = _generateTimeList();
  }

  @override
  Widget build(BuildContext context) {
    String morningStart = _morningStartTime != null
        ? "${_morningStartTime?.hour.toString().padLeft(2, '0')}:${_morningStartTime?.minute.toString().padLeft(2, '0')}"
        : Strings.start;
    String morningEnd = _morningEndTime != null
        ? "${_morningEndTime?.hour.toString().padLeft(2, '0')}:${_morningEndTime?.minute.toString().padLeft(2, '0')}"
        : Strings.end;


    String afternoonStart = _afternoonStartTime != null
        ? "${_afternoonStartTime?.hour.toString().padLeft(2, '0')}:${_afternoonStartTime?.minute.toString().padLeft(2, '0')}"
        : Strings.start;
    String afternoonEnd = _afternoonEndTime != null
        ? "${_afternoonEndTime?.hour.toString().padLeft(2, '0')}:${_afternoonEndTime?.minute.toString().padLeft(2, '0')}"
        : Strings.end;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        color: Theme.of(context).colorScheme.surface
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${DayOfWeek.getItalianName(widget.day.name)}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              GestureDetector(
                onTap: () async => await _save(),
                child: Text(
                  Strings.save,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                )
              )
            ]
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(Strings.free_morning),

                      Switch(
                          value: _isFreeMorning,
                          onChanged: (value){
                            setState(() {
                              _isFreeMorning = value;
                              _morningStartTime = widget.schedule.morningStart;
                              _morningEndTime = widget.schedule.morningEnd;
                            });
                          }
                      )
                    ]
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(Strings.free_afternoon),

                      Switch(
                          value: _isFreeAfternoon,
                          onChanged: (value) {
                            setState(() {
                              _isFreeAfternoon = value;
                              _afternoonStartTime = widget.schedule.afternoonStart;
                              _afternoonEndTime = widget.schedule.afternoonEnd;
                            });
                          }
                      )
                    ]
                ),

                if(!_isFreeMorning) ...[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(Strings.am),

                        Row(
                            spacing: 10,
                            children: [
                              _buildTime(
                                  time: morningStart,
                                  onSelected: (time) => setState(() {
                                    if(time != null) _morningStartTime = time;
                                  }),
                                  startTime: _morningStartTime
                              ),
                              _buildTime(
                                  time: morningEnd,
                                  onSelected: (time) => setState(() {
                                    if(time != null) _morningEndTime = time;
                                  }),
                                  startTime: _morningEndTime
                              )
                            ]
                        )
                      ]
                  )
                ],

                if(!_isFreeAfternoon) ...[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(Strings.pm),

                        Row(
                            spacing: 10,
                            children: [
                              _buildTime(
                                  time: afternoonStart,
                                  onSelected: (time) => setState(() {
                                    if(time != null) _afternoonStartTime = time;
                                  }),
                                  startTime: _afternoonStartTime
                              ),
                              _buildTime(
                                  time: afternoonEnd,
                                  onSelected: (time) => setState(() {
                                    if(time != null) _afternoonEndTime = time;
                                  }),
                                  startTime: _afternoonEndTime
                              )
                            ]
                        )
                      ]
                  )
                ]
              ]
            )
          )
        ]
      )
    );
  }
}
