import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role; // "admin" or "employee"

  const LoginRequested({
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object> get props => [email, password, role];
}

class RegisterRequested extends AuthEvent {
  final dynamic entity; // Can be AdminEntity or EmployeeEntity
  final String role;

  const RegisterRequested({required this.entity, required this.role});

  @override
  List<Object> get props => [entity, role];
}