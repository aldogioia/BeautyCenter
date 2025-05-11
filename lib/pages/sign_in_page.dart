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

  final TextEditingController _emailController = TextEditingController(text: "aldo@gioia.com");
  final TextEditingController _passwordController = TextEditingController(text: "sonoCustomer1");

  bool loading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      final result = await ref.read(authProvider.notifier).signIn(
        email: email,
        password: password,
      );

      if (result.isNotEmpty) {
        SnackBarHandler.instance.showMessage(message: result);
      } else if (result.isEmpty) {
        await ref.refresh(appInitProvider.future);
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 24,
            children: [
              Text("Che bello rivederti", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), //TODO
              TextFormField(
                controller: _emailController,
                validator: InputValidator.validateEmail,
                decoration: const InputDecoration(labelText: Strings.email),
              ),
              TextFormField(
                controller: _passwordController,
                validator: InputValidator.validatePassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: Strings.password),
              ),
              Opacity(
                opacity: 0.5,
                child: GestureDetector(
                  onTap: () {
                    NavigatorService.navigatorKey.currentState?.pushNamed("/password-recovery");
                  },
                  child: Text("Password dimenticata?")
                ),
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
