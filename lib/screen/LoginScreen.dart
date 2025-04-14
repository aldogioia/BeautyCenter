import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/auth_provider.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../security/input_validator.dart';
import '../utils/app_colors.dart';
import '../utils/strings.dart';
import '../widget/CustomTextField.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false){
      String email = _emailController.text;
      String password = _passwordController.text;

      String result = await ref.read(authProvider.notifier).login(email: email, password: password);

      if(result != "") SnackBarHandler.instance.showMessage(message: result);
    }
  }

  void _resetField(){
    // todo vedere come fare, non mi resetta le text field
    _emailController.clear();
    _passwordController.clear();

    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color)
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     Form(
                       key: _formKey,
                       child: Column(
                         children: [
                           CustomTextField(
                             controller: _emailController,
                             labelText: Strings.email,
                             validator: (value) => InputValidator.validateEmail(value),
                             keyboardType: TextInputType.emailAddress,
                           ),

                           const SizedBox(height: 10),

                           CustomTextField(
                             obscureText: true,
                             controller: _passwordController,
                             labelText: Strings.password,
                             validator: (value) => InputValidator.validatePassword(value),
                           ),
                         ]
                       )
                     ),

                      const SizedBox(height: 50),

                      CustomButton(
                        onPressed: () async => await _submitForm(),
                        text: Strings.access
                      ),

                      const SizedBox(height: 50),

                      GestureDetector(
                        onTap: () {
                          _resetField();
                          Navigator.pushNamed(context, "/set_password");
                        },
                        child: Text(
                          Strings.do_not_have_a_password_set_it,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.black.withOpacity(0.5))
                        )
                      )
                    ]
                )
            )
        ),
      )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
