import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hready/app/constant/hive/hive_table_constant.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String password;
  @HiveField(3)
  final String profilePicture;
  @HiveField(4)
  final String name;
  @HiveField(5)
  final String contactNo;
  @HiveField(6)
  final String address;
  @HiveField(7)
  final String role;
  @HiveField(8)
  final String department;
  @HiveField(9)
  final String position;

  UserHiveModel({
    String? userId,
    required this.email,
    required this.password,
    required this.profilePicture,
    required this.name,
    required this.contactNo,
    required this.address,
    required this.role,
    required this.department,
    required this.position
  }) : userId = userId ?? const Uuid().v4();

  // Initial constructor
  const UserHiveModel.initial() :
    userId = '',
    email = '',
    password = '',
    profilePicture = '',
    name = '',
    contactNo = '',
    address = '',
    role = '',
    department = '',
    position = '';

  // From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
      name: entity.name,
      contactNo: entity.contactNo,
      address: entity.address,
      role: entity.role,
      department: entity.department,
      position: entity.position,
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      password: password,
      profilePicture: profilePicture,
      name: name,
      contactNo: contactNo,
      address: address,
      role: role,
      department: department,
      position: position);
  }

  // From Entity List
  static List<UserHiveModel> fromEntityList(List<UserEntity> entityList) {
    return entityList.map((entity) => UserHiveModel.fromEntity(entity)).toList();
  }

  // To Entity List
  static List<UserEntity> toEntityList(List<UserHiveModel> entityList) {
    return entityList.map((data) => data.toEntity()).toList();
  }
  
  @override
  List<Object?> get props => [userId, email, password, profilePicture, name, contactNo, address, role, department, position];

}