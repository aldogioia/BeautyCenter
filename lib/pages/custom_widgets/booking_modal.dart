import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/OperatorDto.dart';
import '../../providers/operator_provider.dart';
import '../../utils/Strings.dart';
import 'operator_item.dart';

class BookingModal extends ConsumerStatefulWidget {
  final String serviceId;

  const BookingModal({super.key, required this.serviceId});

  @override
  ConsumerState<BookingModal> createState() => _ServiceWizardSheetState();
}

class _ServiceWizardSheetState extends ConsumerState<BookingModal> {
  DateTime? _selectedDate;
  OperatorDto? _selectedOperator;
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(operatorProvider.notifier).getAllOperators(widget.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 16,
        children: [
          Text(Strings.selectDay, style: Theme.of(context).textTheme.titleLarge),
          step1(),

          if(_selectedDate != null)
            Text(Strings.selectOperator, style: Theme.of(context).textTheme.titleLarge),
            step2(),

          if(_selectedOperator != null && _selectedDate != null)
            Text(Strings.selectTime, style: Theme.of(context).textTheme.titleLarge),
            step3(),

          if(_selectedTime != null && _selectedOperator != null && _selectedDate != null)
            FilledButton(
              onPressed: () {
                //todo Handle booking confirmation
                Navigator.pop(context);
              },
              child: Text(Strings.book),
            ),
        ],
      ),
    );
  }

  Widget step1() {
    return CalendarDatePicker(
      initialDate: null,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      onDateChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
    );
  }

  Widget step2() {
    final operators = ref.watch(operatorProvider.select((state) => state.operators));

    if (operators.isEmpty) {
      return SizedBox(
          height: 200,
          child: Center(child: Text(Strings.noTimes))
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: operators.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (BuildContext context, int index) {
          final operator = operators[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedOperator = operator;
              });
            },
            child: OperatorItem(
              isSelected: operator == _selectedOperator,
              operator: operator,
            ),
          );
        },
      ),
    );
  }


  Widget step3() {
    final times = ref.watch(operatorProvider.select((state) => state.availableTimes));

    if (times.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(child: Text(Strings.noTimes))
      );
    }

    return CupertinoPicker(
      itemExtent: 20,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedTime = times[index];
        });
      },
      children: times.map((time) => Text(time.toString())).toList()
    );
  }
}
