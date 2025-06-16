import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hready/app/constant/hive/hive_table_constant.dart';
import 'package:hready/features/admin/domain/entities/admin_entity.dart';
import 'package:uuid/uuid.dart';

part 'admin_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.adminTableId)
class AdminHiveModel extends Equatable {
  @HiveField(0)
  final String? adminId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? profilePicture;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String password;
  @HiveField(5)
  final String contactNo;
  @HiveField(6)
  final String role;

  AdminHiveModel({
    String? adminId,
    required this.name,
    required this.profilePicture,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.role,
  }) : adminId = adminId ?? const Uuid().v4();

  // Initial constructor
  const AdminHiveModel.initial() : 
    adminId = '',
    name = '',
    profilePicture = '',
    email = '',
    password = '',
    contactNo = '',
    role = '';
  
  // From Entity
  factory AdminHiveModel.fromEntity(AdminEntity entity) {
    return AdminHiveModel(
      adminId: entity.adminId,
      name: entity.name,
      profilePicture: entity.profilePicture,
      email: entity.email,
      password: entity.password,
      contactNo: entity.contactNo,
      role: entity.role,
    );
  }

  // To Entity
  AdminEntity toEntity() {
    return AdminEntity(
      adminId: adminId,
      name: name,
      profilePicture: profilePicture,
      email: email,
      password: password,
      contactNo: contactNo,
      role: role,
    );
  }

  // From Entity List
  static List<AdminHiveModel> fromEntityList(List<AdminEntity> entityList) {
    return entityList.map((entity) => AdminHiveModel.fromEntity(entity)).toList();
  }

  // To Entity List
  static List<AdminEntity> toEntityList(List<AdminHiveModel> entityList) {
    return entityList.map((data) => data.toEntity()).toList();
  }

  @override
  List<Object?> get props => [adminId, name, profilePicture, email, password, contactNo, role];

}