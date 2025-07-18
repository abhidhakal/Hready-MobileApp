import 'package:hready/features/employee/domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required String? employeeId,
    required String name,
    required String email,
    required String password,
    required String profilePicture,
    required String contactNo,
    required String role,
    required String department,
    required String position,
    required String status,
  }) : super(
          employeeId: employeeId,
          name: name,
          email: email,
          password: password,
          profilePicture: profilePicture,
          contactNo: contactNo,
          role: role,
          department: department,
          position: position,
          status: status,
        );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: '', // Not returned by API
      profilePicture: json['profilePicture'] ?? '',
      contactNo: json['contactNo'] ?? '',
      role: json['role'] ?? 'employee',
      department: json['department'] ?? '',
      position: json['position'] ?? '',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'profilePicture': profilePicture,
      'contactNo': contactNo,
      'role': role,
      'department': department,
      'position': position,
      'status': status,
    };
  }

  static List<EmployeeModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => EmployeeModel.fromJson(e)).toList();
  }
} 