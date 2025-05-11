import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/password_service.dart';
import '../utils/Strings.dart';

part 'password_provider.g.dart';

@riverpod
class Password extends _$Password{
  final PasswordService _passwordService = PasswordService();

  @override
  Future<bool> build() async {
    return true;
  }

  Future<String> sendEmail({
    required String email,
  }) async {
    final response = await _passwordService.sendEmail(email);

    if (response == null) {
      return Strings.connectionError;
    } else if (response.statusCode == 204) {
      return "";
    } else {
      return (response.data as Map<String, dynamic>)['message'];
    }
  }

  Future<String> resetPassword({
    required String token,
    required String password,
  }) async {
    final response = await _passwordService.resetPassword(token, password);

    if (response == null) {
      return Strings.connectionError;
    } else if (response.statusCode == 204) {
      return "";
    } else {
      return (response.data as Map<String, dynamic>)['message'];
    }
  }
}