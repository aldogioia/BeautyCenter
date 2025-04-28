import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/strings.dart';
import '../navigation/navigator.dart';
import '../providers/auth_provider.dart';
import '../utils/input_validator.dart';
import '../utils/snack_bar.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: "Aldo");
  final TextEditingController _surnameController = TextEditingController(text: "Gioia");
  final TextEditingController _phoneController = TextEditingController(text: "3272830636");
  final TextEditingController _emailController = TextEditingController(text: "aldo@gioia.com");
  final TextEditingController _passwordController = TextEditingController(text: "sonoCustomer1");

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final surname = _surnameController.text;
      final phoneNumber = _phoneController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      final result = await ref.read(authProvider.notifier).signUp(
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        email: email,
        password: password
      );

      debugPrint("Result: $result");

      if (result.isNotEmpty){
        SnackBarHandler.instance.showMessage(message: result);
      } else if (result.isEmpty) {
        NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/sign-in", (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  TextFormField(
                    controller: _passwordController,
                    validator: InputValidator.validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: Strings.password),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _submitForm,
                child: const Text(
                  Strings.signUp,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _formKey.currentState?.reset();
                  NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/sign-in", (route) => false);
                },
                child: Text(
                  Strings.alreadyIn,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
