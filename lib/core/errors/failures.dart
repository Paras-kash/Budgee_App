import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final StackTrace? stackTrace;

  const Failure({
    this.message = 'An unexpected error occurred',
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, stackTrace];
}

/// Server failures related to API calls
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.message = 'A server error occurred',
    this.statusCode,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Cache failures related to local storage
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'A cache error occurred',
    super.stackTrace,
  });
}

/// Network failures related to connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'A network error occurred. Please check your connection',
    super.stackTrace,
  });
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.stackTrace,
  });
}

/// Input validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Invalid input', super.stackTrace});
}
