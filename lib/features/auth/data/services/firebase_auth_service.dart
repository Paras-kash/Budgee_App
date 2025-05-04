import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';

/// Service class that wraps Firebase Authentication functionality
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Get the current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign up with email and password
  Future<Either<Failure, UserCredential>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Sign in with email and password
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Sign out the current user
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to sign out: ${e.toString()}'),
      );
    }
  }

  /// Update user profile
  Future<Either<Failure, void>> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'No authenticated user found'));
      }

      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to update profile: ${e.toString()}'),
      );
    }
  }

  /// Send email verification
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'No authenticated user found'));
      }

      await user.sendEmailVerification();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to send verification email: ${e.toString()}',
        ),
      );
    }
  }

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'No authenticated user found'));
      }

      // Re-authenticate user to verify current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(newPassword);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to change password: ${e.toString()}'),
      );
    }
  }

  /// Delete account
  Future<Either<Failure, void>> deleteAccount({
    required String password,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'No authenticated user found'));
      }

      // Re-authenticate user to verify password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Delete account
      await user.delete();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to delete account: ${e.toString()}'),
      );
    }
  }

  /// Handle Firebase authentication exceptions and map to domain failures
  Failure _handleFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'email-already-in-use':
        return AuthFailure(
          message:
              'This email is already registered. Please use a different email or sign in.',
        );
      case 'invalid-email':
        return ValidationFailure(message: 'The email address is not valid.');
      case 'user-disabled':
        return AuthFailure(
          message: 'This account has been disabled. Please contact support.',
        );
      case 'user-not-found':
        return AuthFailure(
          message:
              'No account found with this email address. Please sign up first.',
        );
      case 'wrong-password':
        return AuthFailure(
          message:
              'Incorrect password. Please try again or reset your password.',
        );
      case 'weak-password':
        return ValidationFailure(
          message: 'Password is too weak. Please choose a stronger password.',
        );
      case 'requires-recent-login':
        return AuthFailure(
          message:
              'This operation requires recent authentication. Please sign in again.',
        );
      case 'operation-not-allowed':
        return AuthFailure(
          message: 'This operation is not allowed. Please contact support.',
        );
      case 'too-many-requests':
        return AuthFailure(
          message:
              'Too many unsuccessful login attempts. Please try again later.',
        );
      case 'network-request-failed':
        return NetworkFailure(
          message:
              'Network error occurred. Please check your connection and try again.',
        );
      default:
        return AuthFailure(
          message: exception.message ?? 'An authentication error occurred.',
        );
    }
  }
}
