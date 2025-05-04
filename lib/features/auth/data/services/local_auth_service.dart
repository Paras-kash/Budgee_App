import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/failures.dart';

/// Service for handling local biometric authentication
class LocalAuthService {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;

  // Storage keys for secure data
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _storedEmailKey = 'biometric_email';
  static const String _storedPasswordKey = 'biometric_password';

  LocalAuthService({
    LocalAuthentication? localAuth,
    FlutterSecureStorage? secureStorage,
  }) : _localAuth = localAuth ?? LocalAuthentication(),
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Check if biometric authentication is available on the device
  Future<bool> isBiometricAvailable() async {
    try {
      // Check if hardware exists and is enabled
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      return canAuthenticate;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Check if biometric authentication has been enabled by the user
  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: _biometricEnabledKey);
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  /// Enable or disable biometric authentication
  Future<Either<Failure, void>> setBiometricEnabled({
    required bool enabled,
    String? email,
  }) async {
    try {
      await _secureStorage.write(
        key: _biometricEnabledKey,
        value: enabled.toString(),
      );

      // If enabling biometrics, store the email
      if (enabled && email != null) {
        await _secureStorage.write(key: _storedEmailKey, value: email);
      } else if (!enabled) {
        // If disabling biometrics, clear the stored credentials
        await _secureStorage.delete(key: _storedEmailKey);
        await _secureStorage.delete(key: _storedPasswordKey);
      }

      return const Right(null);
    } catch (e) {
      return Left(
        LocalAuthFailure(
          message:
              'Failed to ${enabled ? "enable" : "disable"} biometric authentication',
        ),
      );
    }
  }

  /// Get email stored for biometric login
  Future<String?> getStoredEmail() async {
    try {
      return await _secureStorage.read(key: _storedEmailKey);
    } catch (_) {
      return null;
    }
  }

  /// Store password in secure storage for biometric login
  Future<Either<Failure, void>> storePassword({
    required String password,
  }) async {
    try {
      await _secureStorage.write(key: _storedPasswordKey, value: password);
      return const Right(null);
    } catch (e) {
      return Left(
        LocalAuthFailure(
          message: 'Failed to store authentication data securely',
        ),
      );
    }
  }

  /// Get stored password for biometric login
  Future<String?> getStoredPassword() async {
    try {
      return await _secureStorage.read(key: _storedPasswordKey);
    } catch (_) {
      return null;
    }
  }

  /// Authenticate user with biometrics (fingerprint, face ID, etc.)
  Future<Either<Failure, bool>> authenticate() async {
    try {
      final isAvailable = await isBiometricAvailable();
      final isEnabled = await isBiometricEnabled();

      if (!isAvailable || !isEnabled) {
        return Left(
          LocalAuthFailure(
            message: 'Biometric authentication is not available or not enabled',
          ),
        );
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your Budgee account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        return const Right(true);
      } else {
        return Left(
          LocalAuthFailure(message: 'Authentication failed or was canceled'),
        );
      }
    } on PlatformException catch (e) {
      return Left(
        LocalAuthFailure(
          message: 'Biometric authentication error: ${e.message}',
        ),
      );
    } catch (e) {
      return Left(
        LocalAuthFailure(message: 'Failed to authenticate with biometrics'),
      );
    }
  }

  /// Store secure value
  Future<Either<Failure, void>> storeSecureValue({
    required String key,
    required String value,
  }) async {
    try {
      await _secureStorage.write(key: key, value: value);
      return const Right(null);
    } catch (e) {
      return Left(LocalAuthFailure(message: 'Failed to store data securely'));
    }
  }

  /// Get secure value
  Future<Either<Failure, String?>> getSecureValue({required String key}) async {
    try {
      final value = await _secureStorage.read(key: key);
      return Right(value);
    } catch (e) {
      return Left(LocalAuthFailure(message: 'Failed to retrieve secure data'));
    }
  }

  /// Delete secure value
  Future<Either<Failure, void>> deleteSecureValue({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
      return const Right(null);
    } catch (e) {
      return Left(LocalAuthFailure(message: 'Failed to delete secure data'));
    }
  }
}
