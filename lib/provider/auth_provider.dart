import 'package:beauty_center_frontend/api/auth_service.dart';
import 'package:beauty_center_frontend/main.dart';
import 'package:beauty_center_frontend/provider/booking_provider.dart';
import 'package:beauty_center_frontend/provider/customer_provider.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:beauty_center_frontend/provider/schedule_exception_provider.dart';
import 'package:beauty_center_frontend/provider/service_provider.dart';
import 'package:beauty_center_frontend/provider/standard_schedule_provider.dart';
import 'package:beauty_center_frontend/security/secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/OperatorDto.dart';
import '../model/enumerators/role.dart';
import '../utils/strings.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final AuthService _authService = AuthService();

  @override
  bool build() {
    return false;
  }

  Future<String> login({required String email, required String password}) async {
    final response = await _authService.login(email: email, password: password);
    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;

      String? accessToken = data['accessToken'];
      String? refreshToken = data['refreshToken'];
      String? id = data['userId'];


      if(accessToken != null && accessToken.startsWith("Bearer ")  && refreshToken != null && id != null) {
        accessToken = accessToken.substring(7);

        await SecureStorage.saveAccessToken(accessToken);
        if(_isAdmin(accessToken)) {
          await SecureStorage.saveAccessToken(accessToken);
          await SecureStorage.saveRefreshToken(refreshToken);
          await SecureStorage.saveUserId(id);
          return "";
        }
      }
      return Strings.authentication_error;
    }
    return (response.data as Map<String, dynamic>)['message'];
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


  Future<String> logout() async {
    final response = await _authService.logout();

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 204) {
      await SecureStorage.deleteAccessToken();
      await SecureStorage.deleteRefreshToken();
      await SecureStorage.deleteUserId();

      ref.read(roomProvider.notifier).reset();
      ref.read(serviceProvider.notifier).reset();
      ref.read(operatorProvider.notifier).reset();
      ref.read(bookingProvider.notifier).reset();
      ref.read(scheduleExceptionProvider.notifier).reset();
      ref.read(standardScheduleProvider.notifier).reset();
      ref.read(customerProvider.notifier).reset();

      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }
}



