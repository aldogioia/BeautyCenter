import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/model/SummaryOperatorDto.dart';
import 'package:beauty_center_frontend/provider/booking_provider.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/utils/date_util.dart';
import 'package:beauty_center_frontend/widget/day_widget.dart';
import 'package:beauty_center_frontend/widget/operator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/OperatorDto.dart';
import '../../model/enumerators/role.dart';
import '../../utils/strings.dart';

class BookingFilterModalBottomSheet extends ConsumerStatefulWidget {
  const BookingFilterModalBottomSheet({
    super.key,
    required this.onSelect
  });

  final void Function(DateTime) onSelect;

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
  SummaryOperatorDto? _selectedOperator;

  @override
  void initState() {
    _endDate = DateTime(_startDate.year + 1, _startDate.month, _startDate.day);
    _days = DateUtil.generateDays(_startDate, _endDate);
    _currentMonth = "${DateUtil.getItalianMonthName(month: _days.first.month)} ${_days.first.year}";
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final double offset = _scrollController.offset;
    final int itemWidth = 50;
    final int index = (offset / itemWidth).floor();

    if (index >= 0 && index < _days.length) {
      final visibleDate = _days[index];
      final newMonth = "${DateUtil.getItalianMonthName(month: visibleDate.month)} ${visibleDate.year}";
      if (newMonth != _currentMonth) {
        setState(() => _currentMonth = newMonth);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final List<OperatorDto> operators = ref.watch(operatorProvider).operators;
    bool condition;

    if(ref.read(operatorProvider).role == Role.ROLE_OPERATOR){
      condition = _selectedDate != null;
      _selectedOperator = ref.watch(bookingProvider).selectedOperator;
    } else {
      condition = _selectedOperator != null && _selectedDate != null;
    }

    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if(condition)...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () async {
                                      final navigator = Navigator.of(context);
                                      if(ref.read(operatorProvider). role == Role.ROLE_ADMIN){
                                        ref.read(bookingProvider.notifier).updateSelectedOperator(
                                            operator: SummaryOperatorDto(
                                                id: _selectedOperator!.id,
                                                name: _selectedOperator!.name,
                                                surname: _selectedOperator!.surname,
                                                imgUrl: _selectedOperator!.imgUrl
                                            )
                                        );
                                      }

                                      final result = await ref.read(bookingProvider.notifier).getOperatorBookings(date: _selectedDate!);

                                      if(result.key) {
                                        widget.onSelect(_selectedDate!);
                                        navigator.pop();
                                      }
                                      else {
                                        SnackBarHandler.instance.showMessage(message: result.value);
                                      }
                                    },
                                    child: Text(
                                      Strings.select_filter,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                                    )
                                ),
                              )
                            ],

                            const SizedBox(height: 25),

                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(Strings.select_day, style: Theme.of(context).textTheme.bodyLarge)
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Text(_currentMonth)
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.only(left: 20, bottom: 10),
                                      child: SizedBox(
                                          height: 70,
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


                                  if(ref.read(operatorProvider).role == Role.ROLE_ADMIN) ...[
                                    const SizedBox(height: 10),

                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(Strings.select_operator, style: Theme.of(context).textTheme.bodyLarge)
                                    ),


                                    Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                                        child: SizedBox(
                                          height: 140,
                                          child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                if(index == operators.length) return const SizedBox(width: 10);

                                                final operator = operators[index];
                                                final summaryDto = SummaryOperatorDto(
                                                    id: operator.id,
                                                    name: operator.name,
                                                    surname: operator.surname,
                                                    imgUrl: operator.imgUrl
                                                );
                                                return OperatorWidget(
                                                    isSelected: _selectedOperator != null && _selectedOperator!.id == operator.id,
                                                    operator: summaryDto,
                                                    onTap: () => setState(() {
                                                      _selectedOperator = summaryDto;
                                                    })
                                                );
                                              },
                                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                                              itemCount: operators.length + 1
                                          ),
                                        )
                                    )
                                  ]
                                ]
                            )
                          ]
                      )
                  )
              ),
            )
        )
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
