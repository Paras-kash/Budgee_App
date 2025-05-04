import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Repository interface for authentication related operations
abstract class AuthRepository {
  /// Get the current authenticated user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Get stream of auth state changes
  Stream<UserEntity?> get authStateChanges;

  /// Sign up with email and password
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with email and password
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  /// Sign in with biometrics
  Future<Either<Failure, UserEntity>> signInWithBiometrics();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Check if biometric auth is available
  Future<bool> isBiometricAvailable();

  /// Enable or disable biometric authentication
  Future<Either<Failure, void>> setBiometricEnabled({
    required bool enabled,
    String? email,
  });

  /// Check if biometric auth is enabled
  Future<bool> isBiometricEnabled();

  /// Update user profile
  Future<Either<Failure, UserEntity>> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Send email verification
  Future<Either<Failure, void>> sendEmailVerification();

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete account
  Future<Either<Failure, void>> deleteAccount({required String password});
}
