import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../providers/auth_provider.dart';
import '../../utils/strings.dart';
import '../navigation/navigator.dart';
import '../providers/global_provider.dart';
import '../utils/input_validator.dart';
import '../handler/snack_bar_handler.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController(text: "3331234511");
  final TextEditingController _passwordController = TextEditingController(text: "sonoCustomer1");

  bool loading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });

      final phoneNumber = _phoneNumberController.text;
      final password = _passwordController.text;

      final result = await ref.read(authProvider.notifier).signIn(
        phoneNumber: phoneNumber,
        password: password,
      );

      if (result.isNotEmpty) {
        SnackBarHandler.instance.showMessage(message: result);
      } else if (result.isEmpty) {
        final _ =  await ref.refresh(appInitProvider.future);
        NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/scaffold", (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.signIn),
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
              Text(Strings.good, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _phoneNumberController,
                validator: InputValidator.validatePhoneNumber,
                decoration: const InputDecoration(labelText: Strings.mobilePhone),
              ),
              TextFormField(
                controller: _passwordController,
                validator: InputValidator.validatePassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: Strings.password),
              ),
              GestureDetector(
                onTap: () {
                  NavigatorService.navigatorKey.currentState?.pushNamed("/password-recovery");
                },
                child: Text(Strings.forgotPassword, style: TextStyle(color: Theme.of(context).colorScheme.primary))
              ),
              FilledButton(
                onPressed: ( loading ? null : () async {
                  await _submitForm();
                  setState(() {
                    loading = false;
                  });
                }),
                child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: loading
                        ? Lottie.asset("assets/lottie/loading.json")
                        : Text(Strings.signIn)
                )
              ),
            ],
          ),
        )
      )
    );
  }
}
