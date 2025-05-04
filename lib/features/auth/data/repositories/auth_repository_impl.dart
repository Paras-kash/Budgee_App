import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/local_auth_service.dart';
import '../services/secure_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final LocalAuthService _localAuthService;
  final SecureStorageService _secureStorageService;

  final StreamController<UserEntity?> _authStateController =
      StreamController<UserEntity?>.broadcast();

  AuthRepositoryImpl({
    required FirebaseAuthService firebaseAuthService,
    required LocalAuthService localAuthService,
    required SecureStorageService secureStorageService,
  }) : _firebaseAuthService = firebaseAuthService,
       _localAuthService = localAuthService,
       _secureStorageService = secureStorageService {
    // Initialize auth state stream
    _firebaseAuthService.authStateChanges.listen((User? user) {
      if (user != null) {
        _authStateController.add(UserModel.fromFirebase(user));
      } else {
        _authStateController.add(null);
      }
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    final user = _firebaseAuthService.currentUser;
    if (user != null) {
      return Right(UserModel.fromFirebase(user));
    }
    return Left(AuthFailure(message: 'No user is currently signed in'));
  }

  @override
  Stream<UserEntity?> get authStateChanges => _authStateController.stream;

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final result = await _firebaseAuthService.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.fold((failure) => Left(failure), (userCredential) async {
      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await _firebaseAuthService.updateProfile(displayName: displayName);
      }

      final user = _firebaseAuthService.currentUser;
      if (user != null) {
        return Right(UserModel.fromFirebase(user));
      }

      return Left(AuthFailure(message: 'Failed to retrieve user after signup'));
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _firebaseAuthService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.fold((failure) => Left(failure), (userCredential) async {
      final user = userCredential.user;
      if (user != null) {
        return Right(UserModel.fromFirebase(user));
      }

      return Left(
        AuthFailure(message: 'Failed to retrieve user after sign in'),
      );
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithBiometrics() async {
    final isBiometricEnabled =
        await _secureStorageService.getBiometricsEnabled();
    if (!isBiometricEnabled) {
      return Left(
        AuthFailure(message: 'Biometric authentication is not enabled'),
      );
    }

    final biometricResult = await _localAuthService.authenticate();

    return biometricResult.fold((failure) => Left(failure), (
      authenticated,
    ) async {
      if (authenticated) {
        final email = await _secureStorageService.getUserEmail();

        if (email == null || email.isEmpty) {
          return Left(
            AuthFailure(
              message: 'No stored credentials for biometric authentication',
            ),
          );
        }

        // Here you'd use the stored credentials to sign in the user
        // In a real app, you might use a refresh token or another secure method
        // This is just a placeholder for demonstration

        // For a real implementation, you might have:
        // 1. A secure way to store and retrieve the user's auth token
        // 2. A method to sign in using that token rather than email/password

        final user = _firebaseAuthService.currentUser;
        if (user != null) {
          return Right(UserModel.fromFirebase(user));
        }

        return Left(
          AuthFailure(
            message: 'Failed to retrieve user after biometric authentication',
          ),
        );
      } else {
        return Left(AuthFailure(message: 'Biometric authentication failed'));
      }
    });
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    return await _firebaseAuthService.sendPasswordResetEmail(email: email);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    final result = await _firebaseAuthService.signOut();
    return result;
  }

  @override
  Future<bool> isBiometricAvailable() async {
    return await _localAuthService.isBiometricAvailable();
  }

  @override
  Future<Either<Failure, void>> setBiometricEnabled({
    required bool enabled,
    String? email,
  }) async {
    try {
      await _secureStorageService.saveBiometricsEnabled(enabled);

      // If enabling biometrics, store the email
      if (enabled && email != null && email.isNotEmpty) {
        await _secureStorageService.saveUserEmail(email);
      }

      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message:
              'Failed to ${enabled ? 'enable' : 'disable'} biometric authentication',
        ),
      );
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return await _secureStorageService.getBiometricsEnabled();
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    final result = await _firebaseAuthService.updateProfile(
      displayName: displayName,
      photoURL: photoUrl,
    );

    return result.fold((failure) => Left(failure), (_) async {
      // Get updated user data
      final user = _firebaseAuthService.currentUser;
      if (user != null) {
        return Right(UserModel.fromFirebase(user));
      }

      return Left(AuthFailure(message: 'Failed to retrieve updated user'));
    });
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    return await _firebaseAuthService.sendEmailVerification();
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _firebaseAuthService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<Either<Failure, void>> deleteAccount({
    required String password,
  }) async {
    return await _firebaseAuthService.deleteAccount(password: password);
  }

  void dispose() {
    _authStateController.close();
  }
}
