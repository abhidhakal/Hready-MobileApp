import 'package:hready/features/payroll/domain/entities/salary.dart';

class SalaryModel extends Salary {
  SalaryModel({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    required super.basicSalary,
    required super.allowances,
    required super.deductions,
    required super.currency,
    required super.status,
    required super.effectiveDate,
    super.endDate,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      id: json['_id'] ?? json['id'],
      employeeId: json['employee'] is String 
          ? json['employee'] 
          : json['employee']['_id'] ?? json['employee']['id'],
      employeeName: json['employee'] is String 
          ? json['employeeName'] ?? 'Unknown'
          : json['employee']['name'] ?? 'Unknown',
      basicSalary: (json['basicSalary'] ?? 0).toDouble(),
      allowances: _convertMapToDouble(json['allowances'] ?? {}),
      deductions: _convertMapToDouble(json['deductions'] ?? {}),
      currency: json['currency'] ?? 'Rs.',
      status: json['status'] ?? 'active',
      effectiveDate: DateTime.parse(json['effectiveDate']),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : null,
      createdBy: json['createdBy'] is String 
          ? json['createdBy'] 
          : json['createdBy']['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  factory SalaryModel.fromEntity(Salary salary) {
    return SalaryModel(
      id: salary.id,
      employeeId: salary.employeeId,
      employeeName: salary.employeeName,
      basicSalary: salary.basicSalary,
      allowances: salary.allowances,
      deductions: salary.deductions,
      currency: salary.currency,
      status: salary.status,
      effectiveDate: salary.effectiveDate,
      endDate: salary.endDate,
      createdBy: salary.createdBy,
      createdAt: salary.createdAt,
      updatedAt: salary.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'basicSalary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'currency': currency,
      'status': status,
      'effectiveDate': effectiveDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static Map<String, double> _convertMapToDouble(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, (value ?? 0).toDouble()));
  }
} 