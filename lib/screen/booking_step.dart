import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/customer_provider.dart';
import 'package:beauty_center_frontend/widget/operator_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/CustomerDto.dart';
import '../model/ServiceDto.dart';
import '../model/summary_operator_dto.dart';
import '../model/enumerators/role.dart';
import '../provider/booking_provider.dart';
import '../provider/operator_provider.dart';
import '../provider/service_provider.dart';
import '../security/input_validator.dart';
import '../utils/Strings.dart';


// todo notifiche locali
class BookingStep extends ConsumerStatefulWidget {
  const BookingStep({super.key});

  @override
  ConsumerState<BookingStep> createState() => _BookingStepState();
}

class _BookingStepState extends ConsumerState<BookingStep> {
  ServiceDto? _selectedService;
  DateTime? _selectedDate;
  SummaryOperatorDto? _selectedOperator;
  TimeOfDay? _selectedHours;
  List<SummaryOperatorDto>? _operators;
  bool _canBook = false;

  final ScrollController _scrollController = ScrollController();
  FixedExtentScrollController? _pickerController;
  final TextEditingController _numberController = TextEditingController();
  String _customerName = "";

  final _formKey = GlobalKey<FormState>();

  void _advanceStep() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _pickerController?.dispose();
    _numberController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    if(ref.read(operatorProvider).role == Role.ROLE_OPERATOR) {
      final current = ref.read(operatorProvider).currentOperator!;
      _selectedOperator = SummaryOperatorDto(
        id: current.id,
        name: current.name,
        surname: current.surname,
        imgUrl: current.imgUrl
      );

    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final List<ServiceDto> services = ref.watch(serviceProvider).services;
    final availableTimes = ref.watch(operatorProvider).availableTimes;
    final customers = ref.watch(customerProvider).customers;


    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.book)
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            _buildServiceStep(services),

            Visibility(
              visible: _selectedService != null,
              child: AnimatedOpacity(
                opacity: _selectedService != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _buildDateStep(),
              )
            ),

            Visibility(

                visible: _selectedDate != null && ref.read(operatorProvider).role == Role.ROLE_ADMIN,
                child: AnimatedOpacity(
                  opacity: _selectedDate != null ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: _buildOperatorStep(),
                )
            ),

            Visibility(
              visible: _selectedOperator != null && _selectedDate != null,
              child: AnimatedOpacity(
                opacity: _selectedOperator != null && _selectedDate != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _buildHoursStep(availableTimes),
              )
            ),

            Visibility(
              visible: _selectedHours != null,
              child: AnimatedOpacity(
                opacity: _selectedHours != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _buildCustomerStep(customers),
              )
            ),

            Visibility(
              visible: _canBook,
              child: AnimatedOpacity(
                opacity: (_canBook) ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: FilledButton(
                    onPressed: () async => await _book(),
                    child: Text(Strings.book) // todo vedere se fare l'animazione con i 3 pallini
                ),
              ),
            ),
          ]
        )
      )
    );
  }


  Widget _buildServiceStep(List<ServiceDto> services) {
    if (services.isEmpty) {
      return Center(child: Text(Strings.no_services_found));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Opacity(
          opacity: 0.5,
          child: Text(Strings.select_service, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ),

        SizedBox(
          height: 150,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final service = services[index];
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      _selectedService = service;
                      _selectedDate = null;
                      if(ref.read(operatorProvider).role == Role.ROLE_ADMIN) _selectedOperator = null;
                      _selectedHours = null;
                    });

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

                    final response = await ref.read(operatorProvider.notifier).getOperatorsByService(serviceId: _selectedService!.id);

                    navigator.pop();

                    if(response.key != null){
                      setState(() => _operators = response.key);
                      _advanceStep();
                    } else {
                      SnackBarHandler.instance.showMessage(message: response.value);
                    }
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.network(
                                service.imgUrl,
                                fit: BoxFit.cover,
                                height: 150,
                                width: 150,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey,
                                    width: 150,
                                    height: 150,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                      color: Colors.grey,
                                      width: 150,
                                      height: 150,
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
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemCount: services.length
          ),
        )
      ]
    );
  }

  Widget _buildDateStep() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Opacity(
              opacity: 0.5,
              child: Text(Strings.select_day, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ))
          ),
          CalendarDatePicker(
              initialDate: null,
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 2),
              onDateChanged: (date) async {
                setState(() {
                  _selectedDate = date;
                  if(ref.read(operatorProvider).role == Role.ROLE_ADMIN) _selectedOperator = null;
                  _selectedHours = null;
                });

                if(_selectedOperator != null) {
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

                  ref.read(operatorProvider.notifier).clearTimes();

                  final result = await ref.read(operatorProvider.notifier).getAvailableHours(
                      operatorId: _selectedOperator!.id,
                      date: _selectedDate!,
                      serviceId: _selectedService!.id
                  );

                  navigator.pop();

                  if(result.key) _advanceStep();
                }


                _advanceStep();
              }
          )
        ]
    );
  }


  Widget _buildOperatorStep() {
    if (_operators == null || _operators!.isEmpty) {
      return Center(child: Text(Strings.no_operators_found));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Opacity(
            opacity: 0.5,
            child: Text(Strings.select_operator, style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ))
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _operators!.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final operator = _operators![i];
              return OperatorWidget(
                onTap: () async {
                  setState(() {
                    _selectedOperator = operator;
                    _selectedHours = null;
                  });

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

                  ref.read(operatorProvider.notifier).clearTimes();

                  final result = await ref.read(operatorProvider.notifier).getAvailableHours(
                      operatorId: _selectedOperator!.id,
                      date: _selectedDate!,
                      serviceId: _selectedService!.id
                  );

                  navigator.pop();

                  if(result.key) _advanceStep();
                },
                isSelected: operator == _selectedOperator,
                operator: operator,
              );
            }
          )
        )
      ]
    );
  }


  Widget _buildHoursStep(List<TimeOfDay> times) {
    _pickerController ??= FixedExtentScrollController(
      initialItem: _selectedHours != null ? times.indexOf(_selectedHours!) : 0,
    );

    if (times.isEmpty) {
      return Center(child: Text(Strings.no_hours));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Opacity(
            opacity: 0.5,
            child: Text(Strings.select_hours, style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ))
        ),
        times.isNotEmpty ?
        SizedBox(
          height: 200,
          child: CupertinoPicker(
            scrollController: _pickerController,
            itemExtent: 32,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedHours = times[index];
              });
              _advanceStep();
            },
            children: times.map((time) {
              return Center(
                  child: Text(
                    "${time.hour.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')}",
                    style: Theme.of(context).textTheme.labelMedium,
                  )
              );
            }).toList(),
          ),
        ) :
        SizedBox(
            height: 200,
            width: double.infinity,
            child: Center(child: Text(Strings.no_hours))
        )
      ],
    );
  }


  Widget _buildCustomerStep(List<CustomerDto> customers){
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          Form(
              key: _formKey,
              child: Column(
                  spacing: 8,
                  children: [
                    // todo vedere come fare, per passare l'id dell'utente se uso l'autoComplete
                    // todo vedere come gestire la validazione, in quando nome e cognome ragggiungo lunghezza massima di 100 insieme
                    Autocomplete<CustomerDto>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if(textEditingValue.text.isEmpty) return const Iterable<CustomerDto>.empty();
                        final searchText = textEditingValue.text.toLowerCase();
                        final searchedItems =  customers.where((c) {
                          final fullName = "${c.name}${c.surname}".toLowerCase();
                          final reversedFullName = "${c.surname}${c.name}".toLowerCase();
                          return fullName.contains(searchText) || reversedFullName.contains(searchText);
                        }).toList();
                        return searchedItems;
                      },
                      onSelected: (customer) {
                        _customerName = "${customer.name} ${customer.surname}";
                        _numberController.text = customer.phoneNumber;
                        setState(() {
                          _canBook = _customerName.isNotEmpty && _numberController.text.isNotEmpty;
                        });
                      },
                      displayStringForOption: (user) => "${user.name} ${user.surname}",
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                                elevation: 4.0,
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          final option = options.elementAt(index);
                                          return ListTile(
                                            title: Text("${option.name} ${option.surname}"),
                                            onTap: () => onSelected(option),
                                          );
                                        }
                                    ),

                                    Positioned(
                                      top: 8,
                                      right: 30,
                                      child: GestureDetector(
                                        onTap: FocusManager.instance.primaryFocus?.unfocus,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.close, size: 24, color: Theme.of(context).colorScheme.primary,),
                                        ),
                                      )
                                    )
                                  ],
                                )
                            )
                        );
                      },
                      fieldViewBuilder: (context, controller, focusNode, onEditingComplete){
                        return TextFormField(
                          validator: (value) => InputValidator.validateName(value),
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          controller: controller,
                          onChanged: (value) {
                            _customerName = value;
                            setState(() => _canBook = _customerName.isNotEmpty && _numberController.text.isNotEmpty);
                          },
                          decoration: InputDecoration(labelText: Strings.name_and_surname)
                        );
                      }
                    ),

                    TextFormField(
                        controller: _numberController,
                        validator: (value) => InputValidator.validatePhoneNumber(value),
                        onChanged: (value) => setState(() => _canBook = _customerName.isNotEmpty && _numberController.text.isNotEmpty),
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
          )
        ]
    );
  }


  Future<void> _book() async {
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
          nameGuest: _customerName,
          phoneNumberGuest: _numberController.text
      );

      navigator.pop();

      if(result.key) navigator.pop();
      SnackBarHandler.instance.showMessage(message: result.value);
    }
  }
}




