import 'package:edone_customer/navigation/navigator.dart';
import 'package:edone_customer/utils/success_ovelay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../utils/strings.dart';
import '../providers/auth_provider.dart';
import '../utils/input_validator.dart';
import '../utils/message_extractor.dart';
import '../handler/snack_bar_handler.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool loading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });

      final name = _nameController.text;
      final surname = _surnameController.text;
      final phoneNumber = _phoneController.text;
      final password = _passwordController.text;

      final result = await ref.read(authProvider.notifier).signUp(
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        password: password
      );

      if (result.isNotEmpty){
        SnackBarHandler.instance.showMessage(message: MessageExtractor.extract(result));
      } else if (result.isEmpty) {
        NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil('/start', (route) => false);
        showSuccessOverlay();
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.signUp),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 24,
            children: [
              Text(Strings.meetYou, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                controller: _passwordController,
                validator: InputValidator.validatePassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: Strings.password),
              ),
              FilledButton(
                onPressed: ( loading ? null : () async {
                  await _submitForm();
                }),
                child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: loading
                        ? Lottie.asset("assets/lottie/loading.json")
                        : Text(Strings.signUp)
                )
              ),
            ],
          ),
        )
      )
    );
  }
}
