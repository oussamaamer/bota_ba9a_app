import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Abstract auth repository contract
abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? role,
    String? businessName,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<bool> isLoggedIn();
}

/// Authentication result containing user and tokens
class AuthResult {
  final User user;
  final String accessToken;
  final String? refreshToken;

  const AuthResult({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });
}
