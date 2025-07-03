import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hready/app/constant/hive/hive_table_constant.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String role;

  @HiveField(4)
  final String? profilePicture;

  @HiveField(5)
  final String? contactNo;

  @HiveField(6)
  final String? department;

  @HiveField(7)
  final String? position;

  @HiveField(8)
  final DateTime? dateOfJoining;

  @HiveField(9)
  final String? status;

  const UserHiveModel({
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
  });

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      profilePicture: entity.profilePicture,
      contactNo: entity.contactNo,
      department: entity.department,
      position: entity.position,
      dateOfJoining: entity.dateOfJoining,
      status: entity.status,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      role: role,
      profilePicture: profilePicture,
      contactNo: contactNo,
      department: department,
      position: position,
      dateOfJoining: dateOfJoining,
      status: status,
    );
  }

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
      ];
}
