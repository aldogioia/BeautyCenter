import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userId = 'user_id';
  static const _notificationsEnabledKey = 'notifications_enabled';

  static Future<void> setNotificationsEnabled(bool enabled) async {
    await _storage.write(key: _notificationsEnabledKey, value: enabled.toString());
  }

  static Future<bool> getNotificationsEnabled() async {
    final value = await _storage.read(key: _notificationsEnabledKey);
    return value == null ? true : value.toLowerCase() == 'true';
  }

  static Future<void> setAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token == null || JwtDecoder.isExpired(token) ? null : token;
  }

  static Future<void> setRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> setUserId(String userId) async {
    await _storage.write(key: _userId, value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _userId);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
