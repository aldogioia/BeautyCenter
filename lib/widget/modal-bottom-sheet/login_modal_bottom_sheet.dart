import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/auth_provider.dart';
import 'package:beauty_center_frontend/provider/global_provider.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/reset_password_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../security/input_validator.dart';
import '../../utils/strings.dart';

class LoginModalBottomSheet extends ConsumerStatefulWidget {
  const LoginModalBottomSheet({super.key});

  @override
  ConsumerState<LoginModalBottomSheet> createState() => _LoginScreenState();

}

class _LoginScreenState extends ConsumerState<LoginModalBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumber = TextEditingController(text: "fra@gmail.com");  // todo svuotare
  final TextEditingController _passwordController = TextEditingController(text: "sonoAdmin1");


  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false){
      final navigator = Navigator.of(context);
      String phoneNumber = _phoneNumber.text;
      String password = _passwordController.text;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      String result = await ref.read(authProvider.notifier).login(phoneNumber: phoneNumber, password: password);

      navigator.pop();

      if(result != "") {
        SnackBarHandler.instance.showMessage(message: result);
      } else {
        final _ = await ref.refresh(appInitProvider.future);
        navigator.pushNamedAndRemoveUntil("/main_scaffold", (route) => false);
      }
    }
  }

  void _resetField(){
    _phoneNumber.clear();
    _passwordController.clear();

    _formKey.currentState?.reset();
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
                Text(Strings.nice_to_see_you_again, style: Theme.of(context).textTheme.headlineSmall),

                Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _phoneNumber,
                        validator: (value) => InputValidator.validatePhoneNumber(value),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: Strings.mobile_phone)
                      ),


                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) => InputValidator.validatePassword(value),
                        decoration: InputDecoration(labelText: Strings.password)
                      ),

                      GestureDetector(
                        onTap: () {
                          _resetField();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            transitionAnimationController: AnimationController(
                                vsync: Navigator.of(context),
                                duration: Duration(milliseconds: 750)
                            ),
                            builder: (context) {
                              return ResetPasswordModalBottomSheet();
                            }
                          );
                        },
                        child: Text(
                          Strings.forgot_your_password,
                          style: Theme.of(context).inputDecorationTheme.labelStyle)
                      )
                    ]
                  )
                ),

                FilledButton(
                    onPressed: () async => await _submitForm(),
                    child: Text(Strings.log_in)
                ),
              ]
            )
          )
        )
      )
    );
  }

  @override
  void dispose() {
    _phoneNumber.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
