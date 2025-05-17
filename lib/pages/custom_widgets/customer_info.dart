import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../model/customer_dto.dart';
import '../../providers/customer_provider.dart';
import '../../utils/Strings.dart';
import '../../utils/input_validator.dart';
import '../../utils/message_extractor.dart';
import '../../handler/snack_bar_handler.dart';
import '../../utils/success_ovelay.dart';

class CustomerInfo extends ConsumerStatefulWidget {
  const CustomerInfo({super.key});

  @override
  ConsumerState<CustomerInfo> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<CustomerInfo> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late final CustomerDto _initialCustomer;
  bool _hasChanged = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initialCustomer = ref.read(customerProvider).customer;

    _nameController.text = _initialCustomer.name;
    _surnameController.text = _initialCustomer.surname;
    _phoneController.text = _initialCustomer.phoneNumber;

    _nameController.addListener(_checkIfChanged);
    _surnameController.addListener(_checkIfChanged);
    _phoneController.addListener(_checkIfChanged);
  }

  void _checkIfChanged() {
    final changed = _nameController.text != _initialCustomer.name ||
        _surnameController.text != _initialCustomer.surname ||
        _phoneController.text != _initialCustomer.phoneNumber;
    if (changed != _hasChanged) {
      setState(() {
        _hasChanged = changed;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_hasChanged) return;

    if (formKey.currentState?.validate() ?? false) {
      String result = await ref.read(customerProvider.notifier).updateCustomer(
        name: _nameController.text,
        surname: _surnameController.text,
        phoneNumber: _phoneController.text,
      );

      if (result.isEmpty) {
        showSuccessOverlay();
        setState(() {
          _hasChanged = false;
        });
      }
      else{
        SnackBarHandler.instance.showMessage(message: MessageExtractor.extract(result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.personalData),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 24,
            children: [
              Text(Strings.personalData, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _nameController,
                validator: InputValidator.validateName,
                decoration: const InputDecoration(labelText: Strings.name),
              ),
              TextFormField(
                controller: _surnameController,
                validator: InputValidator.validateSurname,
                decoration: const InputDecoration(labelText: Strings.surname),
              ),
              TextFormField(
                controller: _phoneController,
                validator: InputValidator.validatePhoneNumber,
                decoration: const InputDecoration(labelText: Strings.mobilePhone),
              ),
              FilledButton(
                onPressed: (loading ? null : () async {
                  await _submitForm();
                  setState(() {
                    loading = false;
                  });
                }),
                style: ButtonStyle(backgroundColor: _hasChanged ? null : WidgetStateProperty.all(Colors.grey)),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: loading
                      ? Lottie.asset("assets/lottie/loading.json")
                      : Text(Strings.update)
                )
              ),
            ],
          ),
        )
      )
    );
  }
}
