import 'package:dio/dio.dart';
import 'package:edone_customer/pages/scaffold_page.dart';
import 'package:edone_customer/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../utils/Strings.dart';
import '../utils/secure_storage.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  Future<bool> _checkTokenAndRefreshIfNeeded() async {
    final accessToken = await SecureStorage.getAccessToken();

    if (accessToken == null || JwtDecoder.isExpired(accessToken)) {
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      try {
        final response = await Dio().post(
          'http://${Strings.ip}:8080/api/v1/auth/refresh',
          options: Options(headers: {'X-Refresh-Token': refreshToken}),
        );

        final newAccessToken = response.data;
        if (newAccessToken != null && !JwtDecoder.isExpired(newAccessToken)) {
          await SecureStorage.setAccessToken(newAccessToken);
          return true;
        }
      } catch (e) {
        debugPrint('Token refresh failed: $e');
        return false;
      }
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _checkTokenAndRefreshIfNeeded(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == false) {
          FlutterNativeSplash.remove();
          return const StartPage();
        } else {
          return const ScaffoldPage();
        }
      },
    );
  }
}

