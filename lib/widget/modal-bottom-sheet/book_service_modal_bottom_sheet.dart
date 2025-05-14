import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/model/SummaryOperatorDto.dart';
import 'package:beauty_center_frontend/provider/booking_provider.dart';
import 'package:beauty_center_frontend/provider/service_provider.dart';
import 'package:beauty_center_frontend/security/input_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/ServiceDto.dart';
import '../../provider/operator_provider.dart';
import '../../utils/date_util.dart';
import '../../utils/strings.dart';
import '../day_widget.dart';
import '../operator_widget.dart';

class BookServiceModalBottomSheet extends ConsumerStatefulWidget {
  const BookServiceModalBottomSheet({super.key});

  @override
  ConsumerState<BookServiceModalBottomSheet> createState() => _BookServiceModalBottomSheetState();
}

class _BookServiceModalBottomSheetState extends ConsumerState<BookServiceModalBottomSheet> {
  int _index = 1;

  ServiceDto? _selectedService;
  DateTime? _selectedDate;
  SummaryOperatorDto? _selectedOperator;
  TimeOfDay? _selectedHours;
  List<SummaryOperatorDto>? _operators;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
        children: List.generate(5, (index){
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


  Widget _chooseServiceStep({required List<ServiceDto> services}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(Strings.select_service, style: Theme.of(context).textTheme.headlineSmall),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if(index == services.length) return const SizedBox(width: 10);

                  final service = services[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedService = service),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Image.network(
                            service.imgUrl,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey,
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                  color: Colors.grey,
                                  width: 10,
                                  height: 100,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image_not_supported)
                              );
                            }
                          ),

                          Positioned(
                            right: 0,
                            bottom: 0,
                            left: 0,
                            top: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black54],
                                ),
                              ),
                            ),
                          ),

                          Text(service.name, textAlign: TextAlign.center),

                          if(_selectedService == service)
                            Positioned(
                                right: 5,
                                top: 5,
                                child: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                            )
                        ]
                      )
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: services.length + 1
              ),
            )
          ),
        ]
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
            child: Text(Strings.select_day, style: Theme.of(context).textTheme.headlineSmall)
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(_currentMonth, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
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
          )
        ]
      )
    );
  }


  // todo gestire il caso in cui non ci sono operatori per quel servizio
  Widget _chooseOperatorStep({required List<SummaryOperatorDto> operators}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(Strings.select_operator, style: Theme.of(context).textTheme.headlineSmall),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 180,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              Strings.select_hours,
              style: Theme.of(context).textTheme.headlineSmall,
            )
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
        Form(
          key: _formKey,
          child: Column(
            spacing: 10,
            children: [
              TextFormField(
                validator: (value) => InputValidator.validateName(value),
                controller: _nameController,
                decoration: InputDecoration(labelText: Strings.name_and_surname)
              ),

              TextFormField(
                controller: _numberController,
                validator: (value) => InputValidator.validatePhoneNumber(value),
                decoration: InputDecoration(labelText: Strings.mobile_phone),
                keyboardType: TextInputType.phone
              )
            ]
          )
        ),

        Text(
          Strings.remember_to_arrive_10_minutes_early,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ) // todo rendere in grassetto la scritta 10 minuti
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

  Future<void> _next() async {
    loadingPopUp() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      );
    }

    final navigator = Navigator.of(context);

    if(_index < 5){
      bool next = true;

      if(_index == 1){
        loadingPopUp();
        final response = await ref.read(operatorProvider.notifier).getOperatorsByService(serviceId: _selectedService!.id);
        navigator.pop();

        if(response.key != null){
          setState(() => _operators = response.key);
        } else {
          SnackBarHandler.instance.showMessage(message: response.value);
          next = false;
        }
      }
      else if(_index == 3) {
        loadingPopUp();

        final result = await ref.read(operatorProvider.notifier).getAvailableHours(
            operatorId: _selectedOperator!.id,
            date: _selectedDate!,
            serviceId: _selectedService!.id
        );
        navigator.pop();

        if(!result.key) {
          SnackBarHandler.instance.showMessage(message: result.value);
          next = false;
        }
      }

      if(next) setState(() => _index += 1);

    } else {
      if(_formKey.currentState?.validate() ?? false){
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

        final result = await ref.read(bookingProvider.notifier).createBookings(
          date: _selectedDate!,
          time: _selectedHours!,
          service: _selectedService!.id,
          operator: _selectedOperator!.id,
          nameGuest: _nameController.text,
          phoneNumberGuest: _numberController.text
        );

        navigator.pop();

        if(result.key) navigator.pop();
        SnackBarHandler.instance.showMessage(message: result.value);
        debugPrint(result.value);
      }
    }
  }


  @override
  void initState() {
    _endDate = DateTime(_startDate.year, _startDate.month + 2, _startDate.day); // todo vedere se va bene
    _days = DateUtil.generateDays(_startDate, _endDate);
    _currentMonth = "${DateUtil.getItalianMonthName(month: _days.first.month)} ${_days.first.year}";
    _scrollController.addListener(_onScroll);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final List<ServiceDto> services = ref.watch(serviceProvider).services;
    final List<TimeOfDay> availableTimes = ref.watch(operatorProvider).availableTimes;

    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                                mainAxisAlignment: _index > 1 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                                children: [
                                  if(_index > 1) ...[
                                    GestureDetector(
                                      onTap: () => setState(() => _index--),
                                      child: Text(
                                        Strings.back,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    )
                                  ],

                                  if((_index == 1 && _selectedService != null)
                                      || (_index == 2 && _selectedDate != null)
                                      || (_index == 3 && _selectedOperator != null)
                                      || (_index == 4 && _selectedHours != null)
                                  )...[
                                    GestureDetector(
                                      onTap: () async => await _next() ,
                                      child: Text(Strings.next),
                                    )
                                  ]
                                ]
                            ),

                            const SizedBox(height: 25),

                            Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 25,
                                children: [
                                  _wizardRow(),

                                  if(_index == 1) _chooseServiceStep(services: services)
                                  else if(_index == 2) _chooseDayStep()
                                  else if(_index == 3) _chooseOperatorStep(operators: _operators!)
                                  else if(_index == 4) _chooseHourStep(times: availableTimes)
                                  else ...[
                                    _chooseCustomerStep(),
                                    if(_nameController.text != "" && _numberController.text != "") ...[
                                      FilledButton(
                                        onPressed: () async => await _next(),
                                        child: Text(Strings.book)
                                      )
                                    ]
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
}
