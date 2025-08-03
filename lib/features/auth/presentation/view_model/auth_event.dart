import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final Map<String, dynamic> payload;

  const RegisterRequested(this.payload);

  @override
  List<Object> get props => [payload];
}

class GetCachedUserRequested extends AuthEvent {
  const GetCachedUserRequested();

  @override
  List<Object> get props => [];
}
