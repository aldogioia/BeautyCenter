import 'package:edone_customer/pages/scaffold_page.dart';
import 'package:edone_customer/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/secure_storage.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<bool> initialAuthCheck = SecureStorage
        .getAccessToken()
        .then((token) => token != null);

    return FutureBuilder<bool>(
      future: initialAuthCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        } else if (snapshot.data == true) {
          return ScaffoldPage();
        } else {
          return SignInPage();
        }
      },
    );
  }
}
