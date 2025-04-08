import 'package:flutter/material.dart';

// todo da modificare

// todo gestire startTime minore di minTime o maggiore di maxTime? e maxTime minore di minTime e viceversa con eccezioni
class CustomHoursPicker extends StatefulWidget {
  const CustomHoursPicker({
    super.key,
    this.minTime = const TimeOfDay(hour: 0, minute: 0),
    this.maxTime = const TimeOfDay(hour: 23, minute: 59),
    this.gap = const Duration(hours: 1),
    this.startTime,
    this.onChanged
  });

  final TimeOfDay minTime;
  final TimeOfDay maxTime;
  final Duration gap;
  final TimeOfDay? startTime;
  final void Function(TimeOfDay)? onChanged;

  @override
  State<CustomHoursPicker> createState() => _CustomHoursPickerState();
}

class _CustomHoursPickerState extends State<CustomHoursPicker> {
  late TimeOfDay _selectedHours;
  final List<TimeOfDay> _times = [];

  @override
  void initState() {
    // todo controlli con le eccezioni

    for(int i = widget.minTime.hour; i <= widget.maxTime.hour; i++) {
      _times.add(TimeOfDay(hour: i, minute: 0));
    }

    if(widget.startTime != null) {
      _selectedHours = widget.startTime!;
    } else {
      _selectedHours = widget.minTime;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            height: 150,
            child: ListWheelScrollView.useDelegate(
                itemExtent: 35,
                physics: const FixedExtentScrollPhysics(),
                perspective: 0.003,
                onSelectedItemChanged: (index) {
                  setState(() => _selectedHours = _times[index]);
                  widget.onChanged;
                },
                childDelegate: ListWheelChildBuilderDelegate(
                    childCount: _times.length,
                    builder: (context, index){
                      bool isSelected = _times[index] == _selectedHours;

                      return Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
                                      : Theme.of(context).colorScheme.surface
                              ),
                              child: Text(
                                "${_times[index].hour.toString().padLeft(2, '0')} : ${_times[index].minute.toString().padLeft(2, '0')}",
                                style: isSelected
                                    ? Theme.of(context).textTheme.labelMedium
                                    : Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.displayMedium!.color!.withOpacity(0.6)),
                              )
                            )
                          ]
                      );
                    }
                )
            )
        )
      ],
    );
  }
}
