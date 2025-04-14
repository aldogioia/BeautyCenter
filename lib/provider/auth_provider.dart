import 'package:beauty_center_frontend/api/auth_service.dart';
import 'package:beauty_center_frontend/security/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/strings.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final AuthService _authService = AuthService();

  @override
  Future<bool> build() async {
    return false;
  }

  Future<String> login({required String email, required String password}) async {
    final response = await _authService.login(email: email, password: password);
    if(response == null) {
      return Strings.connection_error;
    } else if(response.statusCode == 200) {
      String? token = response.headers.value('Authorization');

      if (token != null && token.startsWith("Bearer ")) {
        token = token.substring(7);
        // todo prendere i dati dell'admin e decodificarli per controllare se il ruolo è admin
        await SecureStorage.saveAccessToken(token);
      }
      return "";
    } else {
      return (response.data as Map<String, dynamic>)['message'];
    }
  }
}


