import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final String? employeeId;
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String role;
  final String department;
  final String position;

  const EmployeeEntity({
    required this.employeeId,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.password,
    required this.role,
    required this.department,
    required this.position});
  
  @override
  List<Object?> get props => [employeeId, name, email, password, contactNo, role, department, position];
}