import 'package:equatable/equatable.dart';

/// Auth BLoC events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String? phone;
  final String? role;
  final String? businessName;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
    this.role,
    this.businessName,
  });

  @override
  List<Object?> get props => [email, password, fullName, phone, role, businessName];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}
