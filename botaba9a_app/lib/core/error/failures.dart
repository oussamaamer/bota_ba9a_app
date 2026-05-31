import 'package:equatable/equatable.dart';

/// Base failure class for domain-level error handling.
abstract class Failure extends Equatable {
  final String message;
  final String code;

  const Failure({required this.message, this.code = 'UNKNOWN'});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code = 'SERVER_ERROR'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Pas de connexion internet',
    super.code = 'NETWORK_ERROR',
  });
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code = 'AUTH_ERROR'});
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Erreur de cache local',
    super.code = 'CACHE_ERROR',
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code = 'VALIDATION_ERROR'});
}
