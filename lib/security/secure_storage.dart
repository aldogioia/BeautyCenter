import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();


  static Future<void> saveNotificationsEnabled(bool enabled) async {
    await _storage.write(key: 'notifications_enabled', value: enabled.toString());
  }

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }


  static Future<bool> getNotificationsEnabled() async {
    final value = await _storage.read(key: 'notifications_enabled');
    print("DA STORAGE: ${value == null ? true : value.toLowerCase() == 'true'}");
    return value == null ? true : value.toLowerCase() == 'true';
  }

  static Future<bool?> getNullableNotificationsEnabled() async {
    final value = await _storage.read(key: 'notifications_enabled');
    print("DA STORAGE: ${value == null ? true : value.toLowerCase() == 'true'}");
    return value == null ? null : value.toLowerCase() == 'true';
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  static Future<String?> getUserId() async {
    return _storage.read(key: 'user_id');
  }


  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: 'access_token');
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }

  static Future<void> deleteUserId() async {
    await _storage.delete(key: 'user_id');
  }

}