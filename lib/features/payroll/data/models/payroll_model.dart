import '../../domain/entities/payroll_entity.dart';

class PayrollModel extends PayrollEntity {
  PayrollModel({
    required String id,
    required String employeeId,
    required String employeeName,
    required int month,
    required int year,
    required double basicSalary,
    double? allowances,
    double? deductions,
    String? currency,
    String? status,
    double? grossSalary,
    double? netSalary,
    String? createdBy,
    String? approvedBy,
    DateTime? approvedAt,
    DateTime? paymentDate,
    String? paymentMethod,
    String? transactionId,
  }) : super(
    id: id,
    employeeId: employeeId,
    employeeName: employeeName,
    month: month,
    year: year,
    basicSalary: basicSalary,
    allowances: allowances,
    deductions: deductions,
    currency: currency,
    status: status,
    grossSalary: grossSalary,
    netSalary: netSalary,
    createdBy: createdBy,
    approvedBy: approvedBy,
    approvedAt: approvedAt,
    paymentDate: paymentDate,
    paymentMethod: paymentMethod,
    transactionId: transactionId,
  );

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['_id'] ?? '',
      employeeId: json['employee'] is Map ? json['employee']['_id'] ?? '' : json['employee'] ?? '',
      employeeName: json['employee'] is Map ? json['employee']['name'] ?? '' : '',
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      basicSalary: (json['basicSalary'] ?? 0).toDouble(),
      allowances: (json['allowances'] ?? 0).toDouble(),
      deductions: (json['deductions'] ?? 0).toDouble(),
      currency: json['currency'],
      status: json['status'],
      grossSalary: (json['grossSalary'] ?? 0).toDouble(),
      netSalary: (json['netSalary'] ?? 0).toDouble(),
      createdBy: json['createdBy'] is Map ? json['createdBy']['name'] ?? '' : '',
      approvedBy: json['approvedBy'] is Map ? json['approvedBy']['name'] ?? '' : '',
      approvedAt: json['approvedAt'] != null ? DateTime.tryParse(json['approvedAt']) : null,
      paymentDate: json['paymentDate'] != null ? DateTime.tryParse(json['paymentDate']) : null,
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'employee': employeeId,
      'month': month,
      'year': year,
      'basicSalary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'currency': currency,
      'status': status,
      'grossSalary': grossSalary,
      'netSalary': netSalary,
      'createdBy': createdBy,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'paymentDate': paymentDate?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
    };
  }
} 