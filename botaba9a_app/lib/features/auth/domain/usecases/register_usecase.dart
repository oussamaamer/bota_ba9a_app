import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? role,
    String? businessName,
  }) {
    return repository.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      role: role,
      businessName: businessName,
    );
  }
}
