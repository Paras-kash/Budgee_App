import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive information
class SecureStorageService {
  final FlutterSecureStorage _storage;

  // Storage keys
  static const String _biometricsEnabledKey = 'biometrics_enabled';
  static const String _userEmailKey = 'user_email';
  static const String _userTokenKey = 'user_token';
  static const String _refreshTokenKey = 'refresh_token';

  SecureStorageService()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );

  /// Save biometrics preference
  Future<void> saveBiometricsEnabled(bool enabled) async {
    await _storage.write(key: _biometricsEnabledKey, value: enabled.toString());
  }

  /// Get biometrics preference
  Future<bool> getBiometricsEnabled() async {
    final value = await _storage.read(key: _biometricsEnabledKey);
    return value == 'true';
  }

  /// Save user email for biometric login
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// Save auth token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _userTokenKey, value: token);
  }

  /// Get auth token
  Future<String?> getToken() async {
    return await _storage.read(key: _userTokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Delete all secure data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Delete specific key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
