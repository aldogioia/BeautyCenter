import 'package:beauty_center_frontend/provider/schedule_exception_provider.dart';
import 'package:beauty_center_frontend/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handler/snack_bar_handler.dart';
import '../../security/input_validator.dart';
import '../../utils/strings.dart';

class ScheduleExceptionsModalBottomSheet extends ConsumerStatefulWidget {
  const ScheduleExceptionsModalBottomSheet({
    super.key,
    required this.operatorId
  });

  final String operatorId;

  @override
  ConsumerState<ScheduleExceptionsModalBottomSheet> createState() => _ScheduleExceptionsModalBottomSheetState();
}

class _ScheduleExceptionsModalBottomSheetState extends ConsumerState<ScheduleExceptionsModalBottomSheet> {
  late List<TimeOfDay> _times;

  DateTime? _startDate;
  DateTime? _endDate;

  TimeOfDay? _morningStartTime;
  TimeOfDay? _morningEndTime;
  TimeOfDay? _afternoonStartTime;
  TimeOfDay? _afternoonEndTime;
  late bool _isFreeMorning;
  late bool _isFreeAfternoon;
  late bool _isPeriod;


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


  Widget _buildDate({required DateTime? date, required String startOrEnd, required Function(DateTime) onDateChanged}){
    String dateString = date != null
        ? "${date.day} ${DateUtil.getItalianMonthName(month: date.month)} ${date.year}"
        : startOrEnd;

    return PopupMenuButton(
      itemBuilder: (context){
        return [
          PopupMenuItem(
            child: SizedBox(
              height: 300,
              width: 300,
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 100000)), // todo
                onDateChanged: (DateTime value) {
                  if(value.isAfter(DateTime.now())){
                    onDateChanged(value);
                    Navigator.of(context).pop();
                  } else {
                    SnackBarHandler.instance.showMessage(message: Strings.date_must_be_after_today);
                  }
                }
              )
            )
          )
        ];
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.25).toInt()))
        ),
        child: Text(dateString),
      ),
    );
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


  List<TimeOfDay> _generateTimeList() {
    final List<TimeOfDay> list = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        list.add(TimeOfDay(hour: hour, minute: minute));
      }
    }
    return list;
  }


  Future<void> _save() async {
    if(_startDate == null) {
      SnackBarHandler.instance.showMessage(message: Strings.select_start_date);
    } else if(_startDate!.isBefore(DateTime.now())) {   // todo controllare dateTime.now + 1 giorno?
      SnackBarHandler.instance.showMessage(message: Strings.schedule_exteption_start_date_before_today_error);
    }else if(!InputValidator.validateStartAndEndScheduleTime(start: _morningStartTime, end: _morningEndTime) ||
        !InputValidator.validateStartAndEndScheduleTime(start: _afternoonStartTime, end: _afternoonEndTime)
    ){
      SnackBarHandler.instance.showMessage(message: Strings.start_and_end_times_error);
    } else if(_afternoonStartTime != null && _morningEndTime != null && _afternoonStartTime!.isBefore(_morningEndTime!)){
      SnackBarHandler.instance.showMessage(message: Strings.afternoon_schedule_before_morning_schedule_error);
    } else if(_endDate != null && !_endDate!.isAfter(_startDate!)){
      SnackBarHandler.instance.showMessage(message: Strings.end_date_must_be_after_start_date);
    } else {
      final navigator = Navigator.of(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );

      final result = await ref.read(scheduleExceptionProvider.notifier).createScheduleException(
        startDate: _startDate!,
        endDate: _endDate,
        morningStart: _morningStartTime,
        morningEnd: _morningEndTime,
        afternoonStart: _afternoonStartTime,
        afternoonEnd: _afternoonEndTime,
        operatorId: widget.operatorId
      );

      navigator.pop();

      if(result.key) navigator.pop();
      SnackBarHandler.instance.showMessage(message: result.value);
    }
  }


  @override
  void initState() {
    super.initState();
    _isFreeMorning = true;
    _isFreeAfternoon = true;
    _isPeriod = false;

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
                      Strings.plan,
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
                    // periodo
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(Strings.period),

                          Switch(
                              value: _isPeriod,
                              onChanged: (value) {
                                setState(() {
                                  _isPeriod = value;
                                  _endDate = null;
                                });
                              }
                          )
                        ]
                    ),

                    // data o data inizio
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_isPeriod ? Strings.start : Strings.date),

                          _buildDate(
                            date: _startDate,
                            startOrEnd: Strings.start,
                            onDateChanged: (date) {
                              setState(() => _startDate = date);
                            }
                          )
                        ]
                    ),

                    if(_isPeriod)...[
                      // data fine
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(Strings.end),

                            _buildDate(
                              date: _endDate,
                              startOrEnd: Strings.end,
                              onDateChanged: (date) {
                                setState(() => _endDate = date);
                              }
                            )
                          ]
                      )
                    ],

                    // mattina libera
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
                                  _morningStartTime = null;
                                  _morningEndTime = null;
                                });
                              }
                          )
                        ]
                    ),

                    // pomeriggio libero
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
                                  _afternoonStartTime = null;
                                  _afternoonEndTime = null;
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
