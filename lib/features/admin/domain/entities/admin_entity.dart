import 'package:equatable/equatable.dart';

class AdminEntity extends Equatable {
  final String? adminId;
  final String name;
  final String? profilePicture;
  final String email;
  final String password;
  final String contactNo;
  final String role;

  const AdminEntity({
    required this.adminId,
    required this.name,
    required this.profilePicture,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.role});
  
  @override
  List<Object?> get props => [adminId, name, email, password, role];
}