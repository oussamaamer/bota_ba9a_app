import 'package:equatable/equatable.dart';

/// User domain entity
class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String role;
  final String? businessName;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.role = 'client',
    this.businessName,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, fullName, phone, role, businessName];
}
