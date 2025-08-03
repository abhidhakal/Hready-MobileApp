import 'package:hready/features/payroll/domain/entities/payroll.dart';

class PayrollModel extends Payroll {
  PayrollModel({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    required super.month,
    required super.year,
    required super.basicSalary,
    required super.allowances,
    required super.deductions,
    required super.overtime,
    required super.bonuses,
    required super.leaves,
    required super.currency,
    required super.status,
    super.paymentDate,
    required super.paymentMethod,
    super.transactionId,
    super.notes,
    super.approvedBy,
    super.approvedAt,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['_id'] ?? json['id'],
      employeeId: json['employee'] is String 
          ? json['employee'] 
          : json['employee']['_id'] ?? json['employee']['id'],
      employeeName: json['employee'] is String 
          ? json['employeeName'] ?? 'Unknown'
          : json['employee']['name'] ?? 'Unknown',
      month: json['month'],
      year: json['year'],
      basicSalary: (json['basicSalary'] ?? 0).toDouble(),
      allowances: Map<String, double>.from(json['allowances'] ?? {}),
      deductions: Map<String, double>.from(json['deductions'] ?? {}),
      overtime: Map<String, dynamic>.from(json['overtime'] ?? {}),
      bonuses: Map<String, double>.from(json['bonuses'] ?? {}),
      leaves: Map<String, dynamic>.from(json['leaves'] ?? {}),
      currency: json['currency'] ?? 'Rs.',
      status: json['status'] ?? 'draft',
      paymentDate: json['paymentDate'] != null 
          ? DateTime.parse(json['paymentDate']) 
          : null,
      paymentMethod: json['paymentMethod'] ?? 'bank_transfer',
      transactionId: json['transactionId'],
      notes: json['notes'],
      approvedBy: json['approvedBy'] is String 
          ? json['approvedBy'] 
          : json['approvedBy']?['_id'],
      approvedAt: json['approvedAt'] != null 
          ? DateTime.parse(json['approvedAt']) 
          : null,
      createdBy: json['createdBy'] is String 
          ? json['createdBy'] 
          : json['createdBy']['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  factory PayrollModel.fromEntity(Payroll payroll) {
    return PayrollModel(
      id: payroll.id,
      employeeId: payroll.employeeId,
      employeeName: payroll.employeeName,
      month: payroll.month,
      year: payroll.year,
      basicSalary: payroll.basicSalary,
      allowances: payroll.allowances,
      deductions: payroll.deductions,
      overtime: payroll.overtime,
      bonuses: payroll.bonuses,
      leaves: payroll.leaves,
      currency: payroll.currency,
      status: payroll.status,
      paymentDate: payroll.paymentDate,
      paymentMethod: payroll.paymentMethod,
      transactionId: payroll.transactionId,
      notes: payroll.notes,
      approvedBy: payroll.approvedBy,
      approvedAt: payroll.approvedAt,
      createdBy: payroll.createdBy,
      createdAt: payroll.createdAt,
      updatedAt: payroll.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'month': month,
      'year': year,
      'basicSalary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'overtime': overtime,
      'bonuses': bonuses,
      'leaves': leaves,
      'currency': currency,
      'status': status,
      'paymentDate': paymentDate?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'notes': notes,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 