class PayrollEntity {
  final String id;
  final String employeeId;
  final String employeeName;
  final int month;
  final int year;
  final double basicSalary;
  final double? allowances;
  final double? deductions;
  final String? currency;
  final String? status;
  final double? grossSalary;
  final double? netSalary;
  final String? createdBy;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime? paymentDate;
  final String? paymentMethod;
  final String? transactionId;

  PayrollEntity({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.month,
    required this.year,
    required this.basicSalary,
    this.allowances,
    this.deductions,
    this.currency,
    this.status,
    this.grossSalary,
    this.netSalary,
    this.createdBy,
    this.approvedBy,
    this.approvedAt,
    this.paymentDate,
    this.paymentMethod,
    this.transactionId,
  });
} 