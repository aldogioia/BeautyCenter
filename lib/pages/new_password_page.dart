import 'package:edone_customer/utils/success_ovelay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../navigation/navigator.dart';
import '../providers/password_provider.dart';
import '../utils/Strings.dart';
import '../utils/input_validator.dart';
import '../handler/snack_bar_handler.dart';

class NewPasswordPage extends ConsumerStatefulWidget{
  final String token;

  const NewPasswordPage({
    super.key,
    required this.token
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPasswordState();
}

class _NewPasswordState extends ConsumerState<NewPasswordPage> {
  final GlobalKey<FormState> _formKeyPassword = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool loading = false;

  Future<void> _submitForm() async {
    if (_formKeyPassword.currentState?.validate() ?? false) {
      if (_passwordController.text != _newPasswordController.text) {
        SnackBarHandler.instance.showMessage(message: "Le password non corrispondono");
        return;
      }

      setState(() {
        loading = true;
      });

      final result = await ref.read(passwordProvider.notifier).resetPassword(
        token: widget.token,
        password: _passwordController.text,
      );

      if (result.isEmpty) {
        NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/start", (route) => false);
        showSuccessOverlay();
      } else {
        SnackBarHandler.instance.showMessage(message: result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recupero password"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
            key: _formKeyPassword,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  Text("È il tuo momento! Reimposta la tua nuova password."),

                  TextFormField(
                    controller: _passwordController,
                    validator: InputValidator.validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: Strings.password),
                  ),

                  TextFormField(
                    controller: _newPasswordController,
                    validator: InputValidator.validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: Strings.newPassword),
                  ),

                  FilledButton(
                    onPressed: loading ? null : () async {
                      await _submitForm();
                      setState(() {
                        loading = false;
                      });
                    },
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: loading
                        ? Lottie.asset("assets/lottie/loading.json")
                        : Text("Reimposta la password") //TODO
                    )
                  ),
                ]
            )
        )
      )
    );
  }

}