import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';

class SetPasswordScreen extends ConsumerStatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !RegExp( r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return Strings.insert_a_valid_email_address_error;
    }

    return null;
  }

  void _submitForm(){
    if(_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      // todo richiesta al backend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: CustomTextField(
                    labelText: Strings.email,
                    validator: (value) => _validateEmail(value),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  )
                ),

                const SizedBox(height: 10),

                Text(
                  Strings.set_password_screen_text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(overflow: TextOverflow.visible),
                ),
                
                const SizedBox(height: 50),
                
                CustomButton(
                  onPressed: () => _submitForm(),
                  text: Strings.send_email
                )
              ]
            )
          )
        )
      )
    );
  }

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();

    _formKey.currentState?.reset();
    super.dispose();
  }
}

