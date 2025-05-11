import 'package:edone_customer/providers/customer_provider.dart';
import 'package:edone_customer/utils/message_extractor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../handler/notification_handler.dart';
import '../../model/operator_dto.dart';
import '../../navigation/navigator.dart';
import '../../providers/booking_provider.dart';
import '../../providers/operator_provider.dart';
import '../../utils/Strings.dart';
import '../../handler/snack_bar_handler.dart';
import '../../utils/success_ovelay.dart';
import 'operator_item.dart';

class BookingStep extends ConsumerStatefulWidget {
  final String serviceId;
  final String serviceImage;

  const BookingStep({
    super.key,
    required this.serviceId,
    required this.serviceImage,
  });

  @override
  ConsumerState<BookingStep> createState() => _BookingStepState();
}

class _BookingStepState extends ConsumerState<BookingStep> {
  DateTime? _selectedDate;
  OperatorDto? _selectedOperator;
  String? _selectedTime;
  bool loading = false;

  final ScrollController _scrollController = ScrollController();
  FixedExtentScrollController? _pickerController;

  @override
  void initState() {
    ref.read(operatorProvider.notifier).getAllOperators(widget.serviceId);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pickerController?.dispose();
    super.dispose();
  }

  void _advanceStep() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }


  Future<void> _book() async {
    final customerId = ref.watch(customerProvider).customer.id;
    final result = await ref.read(bookingProvider.notifier).newBooking(
      customerId: customerId,
      operatorId: _selectedOperator!.id,
      serviceId: widget.serviceId,
      date: _selectedDate!,
      time: _selectedTime!,
    );
    if (result.isEmpty) {
      final appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.split(":")[0] as int,
        _selectedTime!.split(":")[1] as int,
      );

      await NotificationHandler.scheduleBookingNotifications(
        appointmentDateTime: appointmentDateTime,
      );

      NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/scaffold", (route) => false);
      showSuccessOverlay();
    } else {
      SnackBarHandler.instance.showMessage(
        message: result.isEmpty ? Strings.booked : MessageExtractor.extract(result),
      );
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final operators = ref.watch(operatorProvider).operators;
    final times = ref.watch(operatorProvider.select((s) => s.availableTimes));

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.book)
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Hero(
                tag: widget.serviceId,
                child: Image.network(
                  widget.serviceImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey,
                      height: 150,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      height: 150,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.white54),
                    );
                  },
                )
              )
            ),

            _buildStep1(),

            Visibility(
              visible: _selectedDate != null,
              maintainState: true,
              child: AnimatedOpacity(
                opacity: _selectedDate != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _buildStep2(operators),
              ),
            ),

            Visibility(
              visible: _selectedOperator != null,
              maintainState: true,
              child: AnimatedOpacity(
                opacity: _selectedOperator != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _buildStep3(times),
              ),
            ),

            Visibility(
              visible: _selectedTime != null,
              maintainState: true,
              child: AnimatedOpacity(
                opacity: _selectedTime != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: FilledButton(
                  onPressed: ( loading ? null : () async {
                    setState(() {
                      loading = true;
                    });
                    await _book();
                  }),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: loading
                      ? Lottie.asset("assets/lottie/loading.json")
                      : Text(Strings.book)
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Opacity(
          opacity: 0.5,
          child: Text(Strings.selectDay, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ))
        ),
        CalendarDatePicker(
          initialDate: null,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 60)),
          onDateChanged: (date){
            setState(() {
              _selectedDate = date;
              _selectedOperator = null;
              _selectedTime = null;
            });

            _advanceStep();
          },
        ),
      ],
    );
  }

  Widget _buildStep2(List<OperatorDto> operators) {
    if (operators.isEmpty) {
      return Center(child: Text(Strings.noOperators));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Opacity(
          opacity: 0.5,
          child: Text(Strings.selectOperator, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ))
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: operators.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final operator = operators[i];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOperator = operator;
                    _selectedTime = null;
                  });

                  ref.read(operatorProvider.notifier).clearTimes();

                  ref.read(operatorProvider.notifier).getAvailableTimes(
                    operatorId: _selectedOperator!.id,
                    serviceId: widget.serviceId,
                    date: _selectedDate!,
                  );

                  _advanceStep();
                },
                child: OperatorItem(
                  isSelected: operator == _selectedOperator,
                  operator: operator,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStep3(List<String> times) {
    _pickerController ??= FixedExtentScrollController(
      initialItem: _selectedTime != null ? times.indexOf(_selectedTime!) : 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Opacity(
          opacity: 0.5,
          child: Text(Strings.selectDay, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ))
        ),
        times.isNotEmpty ?
        SizedBox(
          height: 200,
          child: CupertinoPicker(
            scrollController: _pickerController,
            itemExtent: 32,
            onSelectedItemChanged: (idx) {
              setState(() {
                _selectedTime = times[idx];
              });
              _advanceStep();
            },
            children: times.map((t) => Center(child: Text(t.substring(0, 5)))).toList(),
          ),
        ) :
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Center(child: Text(Strings.noTimes))
        )
      ],
    );
  }
}
