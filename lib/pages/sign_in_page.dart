import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../utils/strings.dart';
import '../navigation/navigator.dart';
import '../utils/input_validator.dart';
import '../utils/snack_bar.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController(text: "aldo@gioia.com");
  final TextEditingController _passwordController = TextEditingController(text: "sonoCustomer1");

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final result = await ref.read(authProvider.notifier).signIn(
        email: email,
        password: password,
      );

      if (result.isNotEmpty) {
        SnackBarHandler.instance.showMessage(message: result);
      } else if (result.isEmpty) {
        NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/scaffold", (route) => false,);
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
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: InputValidator.validateEmail,
                    decoration: const InputDecoration(labelText: Strings.email),
                  ),
                  const SizedBox(height: 16),
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
                  Strings.signIn,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _formKey.currentState?.reset();
                  NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/sign_in", (route) => false,);
                },
                child: Text(
                  Strings.noIn,
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
