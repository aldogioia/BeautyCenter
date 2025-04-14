import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/booking_provider.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/utils/date_util.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/DayWidget.dart';
import 'package:beauty_center_frontend/widget/OperatorWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/OperatorDto.dart';
import '../../utils/strings.dart';

class BookingFilterModalBottomSheet extends ConsumerStatefulWidget {
  const BookingFilterModalBottomSheet({
    super.key,
    required this.onSelect
  });

  final void Function(DateTime, OperatorDto) onSelect;

  @override
  ConsumerState<BookingFilterModalBottomSheet> createState() => _BookingFilterModalBottomSheetState();
}

class _BookingFilterModalBottomSheetState extends ConsumerState<BookingFilterModalBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final DateTime _startDate = DateTime.now();
  late DateTime _endDate;
  late List<DateTime> _days;
  String _currentMonth = "";

  DateTime? _selectedDate;
  OperatorDto? _selectedOperator;

  @override
  void initState() {
    _endDate = DateTime(_startDate.year + 1, _startDate.month, _startDate.day); // todo vedere se va bene come data finale un anno in più
    _days = DateUtil.generateDays(_startDate, _endDate);
    _currentMonth = "${DateUtil.getItalianMonthName(month: _days.first.month)} ${_days.first.year}";
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final double offset = _scrollController.offset;
    final int itemWidth = 40;
    final int index = (offset / itemWidth).floor();

    if (index >= 0 && index < _days.length) {
      final visibleDate = _days[index];
      final newMonth = "${DateUtil.getItalianMonthName(month: visibleDate.month)} ${visibleDate.year}";
      if (newMonth != _currentMonth) {
        setState(() => _currentMonth = newMonth);
      }
    }
  }


  // todo gestire meglio il padding

  @override
  Widget build(BuildContext context) {
    final TextStyle? displayMedium = Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600);
    final TextStyle? labelMedium = Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600);

    final List<OperatorDto> operators = ref.watch(operatorProvider).operators;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(Strings.select_day, style: labelMedium)
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(_currentMonth, style: displayMedium)
        ),
        
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if(index == _days.length) return const SizedBox(width: 10);

                DateTime date = _days[index];
                return DayWidget(
                  isSelected: _selectedDate != null && DateUtil.isSameDay(date1: _selectedDate!, date2: date),
                  date: date,
                  onTap: () => setState(() => _selectedDate = date)
                );
              },
              itemCount: _days.length + 1
            )
          )
        ),

        const SizedBox(height: 10),

        Padding(
            padding: const EdgeInsets.all(10),
            child: Text(Strings.select_operator, style: labelMedium)
        ),


        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          child: SizedBox(
            height: 130,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if(index == operators.length) return const SizedBox(width: 10);

                  final operator = operators[index];
                  return OperatorWidget(
                      isSelected: _selectedOperator != null && _selectedOperator!.id == operator.id,
                      operator: operator,
                      onTap: () => setState(() => _selectedOperator = operator)
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: operators.length + 1
            ),
          )
        ),

        if(_selectedOperator != null && _selectedDate != null)...[
          const SizedBox(height: 25),

          CustomButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final result = await ref.read(bookingProvider.notifier).getOperatorBookings(
                  operatorId: _selectedOperator!.id,
                  date: _selectedDate!
              );

              if(result.key) {
                widget.onSelect(_selectedDate!, _selectedOperator!);
                navigator.pop();
              }
              SnackBarHandler.instance.showMessage(message: result.value);
            },
            text: Strings.select_filter
          )
        ]
      ]
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
