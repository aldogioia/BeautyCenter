import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/customer_dto.dart';
import '../../providers/customer_provider.dart';
import '../../utils/Strings.dart';
import '../../utils/input_validator.dart';
import '../../utils/snack_bar.dart';

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
  final TextEditingController _emailController = TextEditingController();

  late final CustomerDto _initialCustomer;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _initialCustomer = ref.read(customerProvider).customer;

    _nameController.text = _initialCustomer.name;
    _surnameController.text = _initialCustomer.surname;
    _phoneController.text = _initialCustomer.phoneNumber;
    _emailController.text = _initialCustomer.email;

    _nameController.addListener(_checkIfChanged);
    _surnameController.addListener(_checkIfChanged);
    _phoneController.addListener(_checkIfChanged);
    _emailController.addListener(_checkIfChanged);
  }

  void _checkIfChanged() {
    final changed = _nameController.text != _initialCustomer.name ||
        _surnameController.text != _initialCustomer.surname ||
        _phoneController.text != _initialCustomer.phoneNumber ||
        _emailController.text != _initialCustomer.email;

    if (changed != _hasChanged) {
      setState(() {
        _hasChanged = changed;
      });
    }
  }

  Future<void> submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      String result = await ref.read(customerProvider.notifier).updateCustomer(
        name: _nameController.text,
        surname: _surnameController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
      );

      if (result.isEmpty) {
        result = "Dati aggiornati con successo"; //todo
        setState(() {
          _hasChanged = false;
        });
      }
      SnackBarHandler.instance.showMessage(message: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Row(
                mainAxisAlignment: _hasChanged ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(Strings.personalData, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  if (_hasChanged)
                    GestureDetector(
                      onTap: submitForm,
                      child: Text(
                        "Modifica",
                        style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                ]
            ),
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
            TextFormField(
              controller: _emailController,
              validator: InputValidator.validateEmail,
              decoration: const InputDecoration(labelText: Strings.email),
            ),
          ],
        ),
      )
    );
  }
}
