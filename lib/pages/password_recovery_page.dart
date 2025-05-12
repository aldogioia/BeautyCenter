import 'package:edone_customer/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../providers/password_provider.dart';
import '../utils/Strings.dart';
import '../utils/input_validator.dart';
import '../handler/snack_bar_handler.dart';

class PasswordRecoveryPage extends ConsumerStatefulWidget{
  const PasswordRecoveryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends ConsumerState<PasswordRecoveryPage>{
  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyToken = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  bool loading = false;
  bool isTokenVisible = false;

  Future<void> _submitForm() async {
    if (isTokenVisible) {
      if (_formKeyToken.currentState?.validate() ?? false) {
        setState(() {
          loading = true;
        });

        NavigatorService.navigatorKey.currentState?.pushNamed(
            "/new-password", arguments: _tokenController.text);

        setState(() {
          loading = false;
        });
      }
    }
    else {
      if (_formKeyEmail.currentState?.validate() ?? false) {
        setState(() {
          loading = true;
        });

        final result = await ref.read(passwordProvider.notifier).sendEmail(email: _emailController.text);
        if (result.isEmpty) {
          setState(() {
            isTokenVisible = true;
            loading = false;
          });
        } else {
          SnackBarHandler.instance.showMessage(message: result);
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.resetPassword),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 24,
            children: [
              Text(Strings.forgotPassword, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Opacity(
                opacity: 0.5,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: !isTokenVisible
                      ? Text(Strings.noProblem)
                      : Text(Strings.insertToken),
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: isTokenVisible
                    ? tokenForm()
                    : emailForm()
              ),
              FilledButton(
                onPressed: loading ? null : () async {
                  await _submitForm();
                },
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: loading
                      ? Lottie.asset("assets/lottie/loading.json")
                      : Text(isTokenVisible ? Strings.verifyToken : Strings.sendCode)
                )
              )
            ],
        ),
      )
    );
  }

  Widget emailForm(){
    return Form(
        key: _formKeyEmail,
        child: TextFormField(
          controller: _emailController,
          validator: InputValidator.validateEmail,
          decoration: const InputDecoration(labelText: Strings.email),
        )
    );
  }

  Widget tokenForm(){
    return Form(
        key: _formKeyToken,
        child: TextFormField(
          controller: _tokenController,
          validator: InputValidator.validateToken,
          decoration: const InputDecoration(labelText: Strings.token),
        )
    );
  }
}