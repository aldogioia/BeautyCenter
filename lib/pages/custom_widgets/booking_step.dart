import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/operator_dto.dart';
import '../../providers/booking_provider.dart';
import '../../providers/operator_provider.dart';
import '../../utils/Strings.dart';
import '../../utils/input_validator.dart';
import '../../utils/secure_storage.dart';
import '../../utils/snack_bar.dart';
import 'operator_item.dart';

class BookingStep extends ConsumerStatefulWidget {
  final String serviceId;

  const BookingStep({super.key, required this.serviceId});

  @override
  ConsumerState<BookingStep> createState() => _BookingStepState();
}

class _BookingStepState extends ConsumerState<BookingStep> {
  DateTime? _selectedDate;
  OperatorDto? _selectedOperator;
  String? _selectedTime;

  int _currentStep = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _back() {
    if(_currentStep == 4) {
      _formKey.currentState?.reset();
    }

    if(_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _next() async {
    int toAdd = 0;

    if (_currentStep == 0 && _selectedDate != null) {
      ref.read(operatorProvider.notifier)
          .getAllOperators(widget.serviceId);
      toAdd = 1;
    }

    else if (_currentStep == 1 && _selectedOperator != null) {
      ref.read(operatorProvider.notifier)
          .getAvailableTimes(operatorId: _selectedOperator!.id, serviceId: widget.serviceId, date: _selectedDate!);
      toAdd = 1;
    }

    else if (_currentStep == 2 && _selectedTime != null) {
      toAdd = 1;
    }

    else if (_currentStep >=3 && _selectedTime != null) {
      String? name;
      String? phoneNumber;

      if (_formKey.currentState?.validate() ?? false) {
        name = _nameController.text;
        phoneNumber = _phoneNumberController.text;
      }

      final customerId = await SecureStorage.getAccessToken();

      if (customerId == null) {
        SnackBarHandler.instance.showMessage(message: "Errore durante la prenotazione");
        return;
      }

      ref.read(bookingProvider.notifier)
          .newBooking(
            customerId: customerId,
            operatorId: _selectedOperator!.id,
            serviceId: widget.serviceId,
            nameGuest: name,
            phoneNumberGuest: phoneNumber,
            date: _selectedDate!,
            time: _selectedTime!);
    }

    setState(() {
      _currentStep =_currentStep + toAdd;
    });
  }

  Widget _getCurrentStep() {
    switch (_currentStep) {
      case 0:
        return step1();
      case 1:
        return step2();
      case 2:
        return step3();
      case 3:
        return step4();
      case 4:
        return step5();
      default:
        return step1();
    }
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(_currentStep > 0)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BackButton(onPressed: () => _back()),
                Text("Indietro") //todo
              ],
            ),
          _getCurrentStep(),
          FilledButton(
              onPressed: () => _next(),
              child: Text(_currentStep >= 3 ? Strings.book : Strings.forward)
          ),
          if(_currentStep == 3)
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentStep++;
                });
              },
              child: Text(
                Strings.bookForOthers,
                textAlign: TextAlign.center,
              ),
            )
        ]
      )
    );
  }

  Widget step1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(Strings.selectDay, style: Theme.of(context).textTheme.titleLarge),
        CalendarDatePicker(
          initialDate: null,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 60)),
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        )
      ],
    );
  }

  Widget step2() {
    final operators = ref.watch(operatorProvider).operators;

    if (operators.isEmpty) {
      return SizedBox(
          height: 150,
          child: Center(child: Text(Strings.noOperators))
      );
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(Strings.selectOperator, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(
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
          )
        ]
    );
  }

  Widget step3() {
    final times = ref.watch(operatorProvider.select((state) => state.availableTimes));

    if (times.isEmpty) {
      return SizedBox(
          height: 150,
          child: Center(child: Text(Strings.noTimes))
      );
    }

    _selectedTime ??= times.first;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(Strings.selectTime, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(
            height: 100,
            child: CupertinoPicker(
                itemExtent: 25,
                scrollController: FixedExtentScrollController(initialItem: times.indexOf(times[0])),
                selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                  background: Theme.of(context).colorScheme.primary.withAlpha(64),
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedTime = times[index];
                  });
                },
                children: times.map(
                        (time) => Center(
                        child: Text(time.substring(0, 5), style: Theme.of(context).textTheme.titleMedium)
                    )
                ).toList()
            ),
          )
        ]
    );
  }

  Widget step4() {
    return Text("Ricorda di arrivare con 10 minuti di anticipo per non rischiare di perdere l'appuntamento.", textAlign: TextAlign.center,);
  }

  Widget step5() {
    return Column(
      spacing: 32,
      children: [
        Column(
          spacing: 16,
          children: [
            TextFormField(
              controller: _nameController,
              validator: InputValidator.validateName,
              decoration: const InputDecoration(labelText: Strings.name),
            ),
            TextFormField(
              controller: _phoneNumberController,
              validator: InputValidator.validatePhoneNumber,
              obscureText: true,
              decoration: const InputDecoration(labelText: Strings.mobilePhone),
            ),
          ],
        ),
        //Text("Ricorda di arrivare con 10 minuti di anticipo per non rischiare di perdere l'appuntamento."),
      ],
    );
  }
}