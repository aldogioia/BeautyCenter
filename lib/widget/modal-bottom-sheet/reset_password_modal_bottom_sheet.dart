import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/password_provider.dart';
import 'package:beauty_center_frontend/security/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/strings.dart';

class ResetPasswordModalBottomSheet extends ConsumerStatefulWidget {
  const ResetPasswordModalBottomSheet({super.key});

  @override
  ConsumerState<ResetPasswordModalBottomSheet> createState() => _ResetPasswordEmailModalBottomSheetState();
}

class _ResetPasswordEmailModalBottomSheetState extends ConsumerState<ResetPasswordModalBottomSheet> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int _screenIndex = 0;
  bool _showPassword = false;


  String? _validateConfirmPassword() {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if(password == confirmPassword) return null;
    return Strings.confirm_password_must_be_equals_to_new_password;
  }


  Future<void> _sendPhoneNumber() async {
    if(_emailFormKey.currentState?.validate() ?? false){
      final navigator = Navigator.of(context);
      final String phoneNumber = _phoneNumberController.text;

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      );

      final result = await ref.read(passwordProvider.notifier).requestReset(phoneNumber: phoneNumber);

      navigator.pop();

      if(result.key) {
        setState(() => _screenIndex = 1);
      } else {
        SnackBarHandler.instance.showMessage(message: result.value);
      }

    }
  }


  Future<void> _resetPassword() async {
    if(_resetPasswordFormKey.currentState?.validate() ?? false){
      final navigator = Navigator.of(context);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      );

      final result = await ref.read(passwordProvider.notifier).resetPassword(token: _codeController.text, password: _passwordController.text);

      navigator.pop();

      if(result.key) {
        navigator.pop();
        navigator.pop();
      } else {
        SnackBarHandler.instance.showMessage(message: result.value);
      }

    }
  }


  Widget _emailScreen(){
    return Column(
        spacing: 25,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.confirm_email_forget_password),

          Form(
              key: _emailFormKey,
              child: TextFormField(
                  validator: (value) => InputValidator.validatePhoneNumber(value),
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: Strings.mobile_phone,
                      errorMaxLines: 10
                  )
              )
          ),

          FilledButton(
              onPressed: () async => await _sendPhoneNumber(),
              child: Text(Strings.send)
          )
        ]
    );
  }

  Widget _resetPasswordScreen(){
    return Form(
        key: _resetPasswordFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.reset_your_password),

            const SizedBox(height: 25),

            TextFormField(
              validator: (value) => InputValidator.validateResetPasswordCode(value),
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: Strings.verification_code,
                  errorMaxLines: 10
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
                obscureText: !_showPassword,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => InputValidator.validatePassword(value),
                decoration: InputDecoration(
                    labelText: Strings.new_password,
                    errorMaxLines: 10
                )
            ),

            const SizedBox(height: 16),

            TextFormField(
                obscureText: !_showPassword,
                controller: _confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => _validateConfirmPassword(),
                decoration: InputDecoration(
                    labelText: Strings.confirm_password,
                    errorMaxLines: 10
                )
            ),

            const SizedBox(height: 16),

            Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 10,
                children: [
                  Checkbox(
                      value: _showPassword,
                      onChanged: (value) => setState(() => _showPassword = !_showPassword)
                  ),

                  Text(Strings.show_password)
                ]
            ),


            const SizedBox(height: 25),

            FilledButton(
                onPressed: () async => await _resetPassword() ,
                child: Text(Strings.reset_password)
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 25,
                        children: [
                          Text(Strings.forgot_your_password, style: Theme.of(context).textTheme.headlineSmall),

                          if(_screenIndex == 0) _emailScreen(),
                          if(_screenIndex == 1) _resetPasswordScreen(),
                        ]
                    )
                )
            )
        )
    );
  }


  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
  }
}
