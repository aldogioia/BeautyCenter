import 'package:beauty_center_frontend/screen/main_screen/main_scaffold.dart';
import 'package:beauty_center_frontend/screen/start_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../provider/operator_provider.dart';
import '../security/secure_storage.dart';
import '../utils/Strings.dart';

class AuthChecker extends ConsumerStatefulWidget {
  const AuthChecker({super.key});

  @override
  ConsumerState<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends ConsumerState<AuthChecker> {
  late Future<bool> _authCheckFuture;

  @override
  void initState() {
    super.initState();
    _authCheckFuture = _checkTokenAndRefreshIfNeeded();
  }

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
        if (newAccessToken != null && !JwtDecoder.isExpired(newAccessToken) && _isAdmin(newAccessToken)) {
          await SecureStorage.saveAccessToken(newAccessToken);
          return true;
        }
      } catch (e) {
        debugPrint('Token refresh failed: $e');
        return false;
      }

      return false;
    }
    return _isAdmin(accessToken);
  }


  bool _isAdmin(String token) {
    final decodedToken = JwtDecoder.decode(token);
    final role = decodedToken['role'];

    if(role == 'ROLE_ADMIN') {
      ref.read(operatorProvider.notifier).setAdminRole(role);
      return true;
    }
    if(role == 'ROLE_OPERATOR'){
      ref.read(operatorProvider.notifier).setOperatorRole(role);
      return true;
    }

    return false;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == false) {
          return const StartScreen();
        } else {
          return const MainScaffold();
        }
      },
    );
  }
}
