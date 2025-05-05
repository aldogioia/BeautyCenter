import 'package:edone_customer/navigation/navigator.dart';
import 'package:edone_customer/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/customer_dto.dart';
import '../providers/customer_provider.dart';
import '../utils/Strings.dart';
import '../utils/input_validator.dart';
import '../utils/snack_bar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
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
      final result = await ref.read(customerProvider.notifier).updateCustomer(
        name: _nameController.text,
        surname: _surnameController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
      );
      SnackBarHandler.instance.showMessage(message: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.profile,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () async {
                  final result = await ref.read(authProvider.notifier).signOut();
                  if (result.isNotEmpty) {
                    SnackBarHandler.instance.showMessage(message: result);
                  } else {
                    NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/sign-in", (route) => false);
                  }
                },
                icon: Icon(Icons.exit_to_app_rounded),
              )
            ],
          ),
        ),
        Text(
          "I tuoi dati non saranno usati al di fuori delle tue prenotazioni, dunque solo al fine di contattarti in caso di necessità, mai per scopi pubblicitari.",
          textAlign: TextAlign.center,
        ),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
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
              const SizedBox(height: 24),
              if (_hasChanged)
                FilledButton(
                  onPressed: submitForm,
                  child: const Text(
                    "Aggiorna",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
