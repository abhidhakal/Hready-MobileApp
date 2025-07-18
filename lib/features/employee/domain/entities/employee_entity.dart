import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final String? employeeId;
  final String name;
  final String email;
  final String password;
  final String profilePicture;
  final String contactNo;
  final String role;
  final String department;
  final String position;
  final String status;

  const EmployeeEntity({
    required this.employeeId,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.password,
    required this.contactNo,
    required this.role,
    required this.department,
    required this.position,
    required this.status,
  });
  
  @override
  List<Object?> get props => [employeeId, name, email, password, contactNo, role, department, position, status];
}