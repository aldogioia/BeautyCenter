import 'package:edone_customer/model/auth_response_dto.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/auth_service.dart';
import '../navigation/navigator.dart';
import '../utils/Strings.dart';
import '../utils/secure_storage.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final AuthService _authService = AuthService();

  @override
  Future<bool> build() async {
    return true;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _authService.signIn(email: email, password: password);

    if (response == null) {
      return Strings.connectionError;
    } else if (response.statusCode == 200) {
      AuthResponseDto authResponse = AuthResponseDto.fromJson(response.data);

      String accessToken = authResponse.accessToken;

      if (!_isCustomer(accessToken)) {
        return "L'accesso deve avvenire con un account Cliente";
      }

      if (accessToken.startsWith('Bearer ')) {
        await SecureStorage.setAccessToken(accessToken.substring(7));
        await SecureStorage.setRefreshToken(authResponse.refreshToken);
        await SecureStorage.setUserId(authResponse.userId);
      }

      return "";
    } else {
      return (response.data as Map<String, dynamic>)['message'];
    }
  }

  Future<String> signOut() async {
    final response = await _authService.signOut();
    if (response == null) {
      return Strings.connectionError;
    } else if (response.statusCode == 204) {
      await SecureStorage.clearAll();
      NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/sign-in", (route) => false,);
      return "";
    } else {
      return (response.data as Map<String, dynamic>)['message'];
    }
  }

  Future<String> signUp({
    required String name,
    required String surname,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    final response = await _authService.signUp(
      name: name,
      surname: surname,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );

    if (response == null) {
      return Strings.connectionError;
    } else if (response.statusCode == 201) {
      return "";
    } else {
      return (response.data as Map<String, dynamic>)['message'];
    }
  }

  bool _isCustomer(String token) {
    final decodedToken = JwtDecoder.decode(token);
    final role = decodedToken['role'];
    return role == 'ROLE_CUSTOMER';
  }
}
