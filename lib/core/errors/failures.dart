/// Base failure class for domain failures
abstract class Failure {
  final String message;

  const Failure({required this.message});

  void fold(
    void Function(dynamic failure) param0,
    void Function(dynamic _) param1,
  ) {}
}

/// Represents failures related to authentication
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Represents failures related to local authentication (biometrics, etc.)
class LocalAuthFailure extends Failure {
  const LocalAuthFailure({required super.message});
}

/// Represents failures related to form validation
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Represents failures related to server communication
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Represents failures related to network connectivity
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Represents failures related to cache operations
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Represents failures related to permissions
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// Represents failures related to insufficient funds
class InsufficientFundsFailure extends Failure {
  const InsufficientFundsFailure({required super.message});
}

/// Represents unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
