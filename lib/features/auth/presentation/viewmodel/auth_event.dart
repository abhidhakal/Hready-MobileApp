import 'package:equatable/equatable.dart';
import 'package:hready/features/admin/data/models/admin_hive_model.dart';
import 'package:hready/features/employee/data/models/employee_hive_model.dart';

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

class RegisterAdmin extends AuthEvent {
  final AdminHiveModel admin;

  const RegisterAdmin(this.admin);

  @override
  List<Object> get props => [admin];
}

class RegisterEmployee extends AuthEvent {
  final EmployeeHiveModel employee;

  const RegisterEmployee(this.employee);

  @override
  List<Object> get props => [employee];
}
