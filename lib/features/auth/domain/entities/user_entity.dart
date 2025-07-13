import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String role;
  final String? profilePicture;
  final String? contactNo;
  final String? department;
  final String? position;
  final DateTime? dateOfJoining;
  final String? status;
  final String token;

  const UserEntity({
    this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.profilePicture,
    this.contactNo,
    this.department,
    this.position,
    this.dateOfJoining,
    this.status,
    required this.token,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        email,
        role,
        profilePicture,
        contactNo,
        department,
        position,
        dateOfJoining,
        status,
        token,
      ];
}
