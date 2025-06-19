import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String email;
  final String password;
  final String profilePicture;
  final String name;
  final String contactNo;
  final String address;
  final String role;
  final String department;
  final String position;

  const UserEntity({required this.userId, required this.email, required this.password, required this.profilePicture, required this.name, required this.contactNo, required this.address, required this.role, required this.department, required this.position});
  
  @override
  List<Object?> get props => [userId, email, password, profilePicture, name, contactNo, address, role, department, position];
}