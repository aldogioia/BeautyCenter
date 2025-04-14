import 'package:beauty_center_frontend/security/input_validator.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/OperatorDto.dart';
import '../../provider/operator_provider.dart';
import '../../utils/date_util.dart';
import '../../utils/strings.dart';
import '../DayWidget.dart';
import '../OperatorWidget.dart';

class BookServiceModalBottomSheet extends ConsumerStatefulWidget {
  const BookServiceModalBottomSheet({super.key});

  @override
  ConsumerState<BookServiceModalBottomSheet> createState() => _BookServiceModalBottomSheetState();
}

class _BookServiceModalBottomSheetState extends ConsumerState<BookServiceModalBottomSheet> {
  int _index = 1;

  DateTime? _selectedDate;
  OperatorDto? _selectedOperator;
  TimeOfDay? _selectedHours;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();     // todo vedere se fare email o nome e cognome

  final ScrollController _scrollController = ScrollController();
  final DateTime _startDate = DateTime.now();
  late DateTime _endDate;
  String _currentMonth = "";
  late List<DateTime> _days;

  Widget _wizardRow(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index){
          TextStyle? textStyle = Theme.of(context).textTheme.labelMedium;
          if(_index <= index) textStyle = textStyle?.copyWith(color: Theme.of(context).colorScheme.primary);

          return Container(
              padding: const EdgeInsets.all(5),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: _index >= index + 1
                      ? Theme.of(context).colorScheme.primary.withAlpha((255 * 0.25).toInt())
                      : Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.5).toInt()),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Text(
                "${index + 1}",
                style: textStyle,
              )
          );
        }),
      ),
    );
  }

  Widget _chooseDayStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(Strings.select_day, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600))
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(_currentMonth, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600))
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
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
          )
        ]
      )
    );
  }


  Widget _chooseOperatorStep({required List<OperatorDto> operators}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(Strings.select_operator, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
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
        ]
      )
    );
  }


  // todo gestire il caso in cui non ci sono orari disponibili
  Widget _chooseHourStep({required List<TimeOfDay> times}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(Strings.select_hours, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 200,
              child: CupertinoPicker(
                // scrollController: FixedExtentScrollController(initialItem: _selectedIndex),
                itemExtent: 40,
                onSelectedItemChanged: (int index) {
                  setState(() => _selectedHours = times[index]);
                },
                selectionOverlay: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.25).toInt()),
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                children: times.map((time) {
                  return Center(
                    child: Text(
                      "${time.hour.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')}",
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  );
                }).toList(),
              ),
            )
          )
        ]
      )
    );
  }


  Widget _chooseCustomerStep(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 25,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).inputDecorationTheme.border!.borderSide.color),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                CustomTextField(                      // todo vedere se fare email o nome e cognome
                  controller: _emailController,
                  validator: (value) => InputValidator.validateEmail(value),
                  labelText: Strings.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                CustomTextField(
                  controller: _numberController,
                  validator: (value) => InputValidator.validatePhoneNumber(value),
                  labelText: Strings.mobile_phone,
                  keyboardType: TextInputType.phone,
                )
              ]
            )
          )
        ),

        Text(Strings.remember_to_arrive_10_minutes_early, style: Theme.of(context).textTheme.labelMedium) // todo renedere in grassetto la scritta 10 minuti
      ]
    );
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


  @override
  void initState() {
    _endDate = DateTime(_startDate.year + 1, _startDate.month, _startDate.day); // todo vedere se va bene come data finale un anno in più
    _days = DateUtil.generateDays(_startDate, _endDate);
    _currentMonth = "${DateUtil.getItalianMonthName(month: _days.first.month)} ${_days.first.year}";
    _scrollController.addListener(_onScroll);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final List<OperatorDto> operators = ref.watch(operatorProvider).operators;
    final List<TimeOfDay> availableTimes = ref.watch(operatorProvider).availableTimes;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 25,
      children: [
        _wizardRow(),

        if(_index == 1) _chooseDayStep()
        else if(_index == 2) _chooseOperatorStep(operators: operators)
        else if(_index == 3) _chooseHourStep(times: availableTimes)
        else _chooseCustomerStep(),

        if((_index == 1 && _selectedDate != null)
            || (_index == 2 && _selectedOperator != null)
            || (_index == 3 && _selectedHours != null)
            || (_index == 4 && _emailController.text != "" && _numberController.text != "")
        )
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomButton(
              onPressed: () async {
                if(_index < 4){
                  if(_index == 2) {
                    await ref.read(operatorProvider.notifier).getAvailableHours(
                      operatorId: _selectedOperator!.id,
                      date: _selectedDate!,
                      serviceId: "" // todo vedere come prendere il serviceId, e vedere se fare una specie di loader mentre fa la chiamata
                    );
                  }
                  setState(() => _index += 1);
                } else {
                  if(_formKey.currentState?.validate() ?? false){
                    // todo chiamata all'api
                  }
                }
              },
              text: _index == 4 ? Strings.book : Strings.next
            ),
          )
      ]
    );
  }
}
