import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hready/app/constant/hive/hive_table_constant.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';
import 'package:uuid/uuid.dart';

part 'employee_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.employeeTableId)
class EmployeeHiveModel extends Equatable {
  @HiveField(0)
  final String? employeeId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String profilePicture;
  @HiveField(5)
  final String contactNo;
  @HiveField(6)
  final String role;
  @HiveField(7)
  final String department;
  @HiveField(8)
  final String position;

  EmployeeHiveModel({
    String? employeeId,
    required this.name,
    required this.email,
    required this.password,
    required this.profilePicture,
    required this.contactNo,
    required this.role,
    required this.department,
    required this.position,
  }) : employeeId = employeeId ?? const Uuid().v4();

  // From Entity
  factory EmployeeHiveModel.fromEntity(EmployeeEntity entity) {
    return EmployeeHiveModel(
      employeeId: entity.employeeId,
      name: entity.name,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
      contactNo: entity.contactNo,
      role: entity.role,
      department: entity.department,
      position: entity.position,
    );
  }

  // To Entity
  EmployeeEntity toEntity() {
    return EmployeeEntity(
      employeeId: employeeId,
      name: name,
      email: email,
      password: password,
      profilePicture: profilePicture,
      contactNo: contactNo,
      role: role,
      department: department,
      position: position,
    );
  }

  @override
  List<Object?> get props => [
        employeeId,
        name,
        email,
        password,
        profilePicture,
        contactNo,
        role,
        department,
        position
      ];
}