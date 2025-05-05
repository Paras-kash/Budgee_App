import 'dart:developer' as dev;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/config/dependency_injection.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

enum AuthState { initial, authenticated, unauthenticated, loading, error }

/// AuthNotifier to manage authentication state
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _authRepository;

  @override
  FutureOr<AuthState> build() async {
    _authRepository = getIt<AuthRepository>();

    // Listen to auth state changes
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        dev.log('Auth state changed: User authenticated', name: 'AuthNotifier');
        state = const AsyncValue.data(AuthState.authenticated);
      } else {
        dev.log(
          'Auth state changed: User unauthenticated',
          name: 'AuthNotifier',
        );
        state = const AsyncValue.data(AuthState.unauthenticated);
      }
    });

    // Check initial auth state
    final userResult = await _authRepository.getCurrentUser();
    return userResult.fold(
      (failure) {
        dev.log('Initial auth check: No user found', name: 'AuthNotifier');
        return AuthState.unauthenticated;
      },
      (user) {
        final isAuthenticated = user.id.isNotEmpty;
        dev.log(
          'Initial auth check: User ${isAuthenticated ? "authenticated" : "unauthenticated"}',
          name: 'AuthNotifier',
        );
        return isAuthenticated
            ? AuthState.authenticated
            : AuthState.unauthenticated;
      },
    );
  }

  /// Get the current user
  Future<UserEntity?> getCurrentUser() async {
    dev.log('Getting current user', name: 'AuthNotifier');
    final result = await _authRepository.getCurrentUser();
    return result.fold(
      (failure) {
        dev.log(
          'Failed to get current user: ${failure.message}',
          name: 'AuthNotifier',
        );
        return null;
      },
      (user) {
        dev.log('Current user retrieved: ${user.email}', name: 'AuthNotifier');
        return user;
      },
    );
  }

  /// Sign up with email and password
  Future<Failure?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    dev.log('Signing up user: $email', name: 'AuthNotifier');
    state = const AsyncValue.loading();

    try {
      final result = await _authRepository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      return result.fold(
        (failure) {
          dev.log('Sign up failed: ${failure.message}', name: 'AuthNotifier');
          state = AsyncValue.error(failure, StackTrace.current);
          return failure;
        },
        (user) {
          dev.log(
            'Sign up successful for user: ${user.email}',
            name: 'AuthNotifier',
          );
          state = const AsyncValue.data(AuthState.authenticated);
          return null;
        },
      );
    } catch (e, stack) {
      dev.log(
        'Unexpected error during sign up: $e',
        name: 'AuthNotifier',
        error: e,
        stackTrace: stack,
      );
      final failure = ServerFailure(
        message: 'An unexpected error occurred: $e',
      );
      state = AsyncValue.error(failure, stack);
      return failure;
    }
  }

  /// Sign in with email and password
  Future<Failure?> signIn({
    required String email,
    required String password,
  }) async {
    dev.log('Signing in user: $email', name: 'AuthNotifier');
    state = const AsyncValue.loading();

    try {
      final result = await _authRepository.signIn(
        email: email,
        password: password,
      );

      return result.fold(
        (failure) {
          dev.log('Sign in failed: ${failure.message}', name: 'AuthNotifier');
          state = AsyncValue.error(failure, StackTrace.current);
          return failure;
        },
        (user) {
          dev.log(
            'Sign in successful for user: ${user.email}',
            name: 'AuthNotifier',
          );
          state = const AsyncValue.data(AuthState.authenticated);
          return null;
        },
      );
    } catch (e, stack) {
      dev.log(
        'Unexpected error during sign in: $e',
        name: 'AuthNotifier',
        error: e,
        stackTrace: stack,
      );
      final failure = ServerFailure(
        message: 'An unexpected error occurred: $e',
      );
      state = AsyncValue.error(failure, stack);
      return failure;
    }
  }

  /// Sign in with biometrics
  Future<Failure?> signInWithBiometrics() async {
    dev.log('Signing in with biometrics', name: 'AuthNotifier');
    state = const AsyncValue.loading();

    try {
      final result = await _authRepository.signInWithBiometrics();

      return result.fold(
        (failure) {
          dev.log(
            'Biometric sign in failed: ${failure.message}',
            name: 'AuthNotifier',
          );
          state = AsyncValue.error(failure, StackTrace.current);
          return failure;
        },
        (user) {
          dev.log(
            'Biometric sign in successful for user: ${user.email}',
            name: 'AuthNotifier',
          );
          state = const AsyncValue.data(AuthState.authenticated);
          return null;
        },
      );
    } catch (e, stack) {
      dev.log(
        'Unexpected error during biometric sign in: $e',
        name: 'AuthNotifier',
        error: e,
        stackTrace: stack,
      );
      final failure = ServerFailure(
        message: 'An unexpected error occurred: $e',
      );
      state = AsyncValue.error(failure, stack);
      return failure;
    }
  }

  /// Send password reset email
  Future<Failure?> sendPasswordResetEmail({required String email}) async {
    dev.log('Sending password reset email to: $email', name: 'AuthNotifier');
    try {
      final result = await _authRepository.sendPasswordResetEmail(email: email);

      return result.fold(
        (failure) {
          dev.log(
            'Failed to send password reset email: ${failure.message}',
            name: 'AuthNotifier',
          );
          return failure;
        },
        (_) {
          dev.log(
            'Password reset email sent successfully',
            name: 'AuthNotifier',
          );
          return null;
        },
      );
    } catch (e, stack) {
      dev.log(
        'Unexpected error during password reset email: $e',
        name: 'AuthNotifier',
        error: e,
        stackTrace: stack,
      );
      final failure = ServerFailure(
        message: 'An unexpected error occurred: $e',
      );
      return failure;
    }
  }

  /// Sign out
  Future<Failure?> signOut() async {
    dev.log('Signing out user', name: 'AuthNotifier');
    state = const AsyncValue.loading();

    try {
      final result = await _authRepository.signOut();

      return result.fold(
        (failure) {
          dev.log('Sign out failed: ${failure.message}', name: 'AuthNotifier');
          state = AsyncValue.error(failure, StackTrace.current);
          return failure;
        },
        (_) {
          dev.log('Sign out successful', name: 'AuthNotifier');
          state = const AsyncValue.data(AuthState.unauthenticated);
          return null;
        },
      );
    } catch (e, stack) {
      dev.log(
        'Unexpected error during sign out: $e',
        name: 'AuthNotifier',
        error: e,
        stackTrace: stack,
      );
      final failure = ServerFailure(
        message: 'An unexpected error occurred: $e',
      );
      state = AsyncValue.error(failure, stack);
      return failure;
    }
  }

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    dev.log(
      'Checking if biometric authentication is available',
      name: 'AuthNotifier',
    );
    return await _authRepository.isBiometricAvailable();
  }

  /// Check if biometric authentication is enabled
  Future<bool> isBiometricEnabled() async {
    dev.log(
      'Checking if biometric authentication is enabled',
      name: 'AuthNotifier',
    );
    return await _authRepository.isBiometricEnabled();
  }

  /// Enable or disable biometric authentication
  Future<Failure?> setBiometricEnabled(bool enabled) async {
    dev.log(
      '${enabled ? "Enabling" : "Disabling"} biometric authentication',
      name: 'AuthNotifier',
    );
    // If enabling biometrics, get current user email
    String? email;
    if (enabled) {
      final user = await getCurrentUser();
      email = user?.email;
    }

    try {
      final result = await _authRepository.setBiometricEnabled(
        enabled: enabled,
        email: email,
      );

      return result.fold(
        (failure) {
          dev.log(
            'Failed to ${enabled ? "enable" : "disable"} biometric authentication: ${failure.message}',
            name: 'AuthNotifier',
          );
          return failure;
        },
        (_) {
          dev.log(
            'Biometric authentication ${enabled ? "enabled" : "disabled"} successfully',
            name: 'AuthNotifier',
          );
          return null;
        },
      );
    } catch (e, stack) {
      dev.log(
        'Unexpected error during biometric authentication toggle: $e',
        name: 'AuthNotifier',
        error: e,
        stackTrace: stack,
      );
      final failure = ServerFailure(
        message: 'An unexpected error occurred: $e',
      );
      return failure;
    }
  }
}

/// Provider for the current authenticated user
@riverpod
Future<UserEntity?> currentUser(CurrentUserRef ref) async {
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  return await authNotifier.getCurrentUser();
}
