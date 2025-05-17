import 'package:edone_customer/utils/success_ovelay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../handler/snack_bar_handler.dart';
import '../navigation/navigator.dart';
import '../providers/password_provider.dart';
import '../utils/Strings.dart';
import '../utils/input_validator.dart';

class UpdatePasswordPage extends ConsumerStatefulWidget{
  const UpdatePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends ConsumerState<UpdatePasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool loading = false;


  Future<void> _submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });

      String result = await ref.read(passwordProvider.notifier).updatePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );



      if (result.isNotEmpty) {
        SnackBarHandler.instance.showMessage(message: result);
      } else {
        NavigatorService.navigatorKey.currentState?.pop();
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
        title: Text(Strings.password),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 24,
            children: [
              Text(Strings.updatePassword, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _oldPasswordController,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return Strings.required;
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(labelText: Strings.oldPassword),
              ),
              TextFormField(
                controller: _newPasswordController,
                validator: InputValidator.validatePassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: Strings.newPassword),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty || value != _newPasswordController.text) {
                    return Strings.passwordNotMatch;
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(labelText: Strings.confirmPassword),
              ),
              FilledButton(
                  onPressed: (loading ? null : () async {
                    await _submitForm();
                  }),
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: loading
                          ? Lottie.asset("assets/lottie/loading.json")
                          : Text(Strings.update)
                  )
              ),
            ]
          )
        )
      )
    );
  }
}