import 'package:beauty_center_frontend/api/password_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/strings.dart';

part 'password_provider.g.dart';

@riverpod
class Password extends _$Password {
  final PasswordService _passwordService = PasswordService();

  @override
  Future<bool> build() async {
    return false;
  }


  Future<MapEntry<bool, String>> requestReset({required String phoneNumber}) async {
    final response = await _passwordService.requestReset(phoneNumber: phoneNumber);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204) return MapEntry(true, "");
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> resetPassword({required String token, required String password}) async {
    final response = await _passwordService.reset(token: token, password: password);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204) return MapEntry(true, "");
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }
}