class SalaryModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final double basicSalary;
  final Map<String, dynamic>? allowances;
  final Map<String, dynamic>? deductions;
  final String? currency;
  final DateTime? effectiveDate;
  final String? notes;
  final double? taxPercentage;
  final double? insurancePercentage;
  final double? grossSalary;
  final double? netSalary;
  final double? totalAllowances;
  final double? totalDeductions;
  final String? status;

  SalaryModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.basicSalary,
    this.allowances,
    this.deductions,
    this.currency,
    this.effectiveDate,
    this.notes,
    this.taxPercentage,
    this.insurancePercentage,
    this.grossSalary,
    this.netSalary,
    this.totalAllowances,
    this.totalDeductions,
    this.status,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      id: json['_id'] ?? '',
      employeeId: json['employee'] is Map ? json['employee']['_id'] ?? '' : json['employee'] ?? '',
      employeeName: json['employee'] is Map ? json['employee']['name'] ?? '' : '',
      basicSalary: (json['basicSalary'] ?? 0).toDouble(),
      allowances: json['allowances'] as Map<String, dynamic>?,
      deductions: json['deductions'] as Map<String, dynamic>?,
      currency: json['currency'],
      effectiveDate: json['effectiveDate'] != null ? DateTime.tryParse(json['effectiveDate']) : null,
      notes: json['notes'],
      taxPercentage: (json['taxPercentage'] ?? 0).toDouble(),
      insurancePercentage: (json['insurancePercentage'] ?? 0).toDouble(),
      grossSalary: (json['grossSalary'] ?? 0).toDouble(),
      netSalary: (json['netSalary'] ?? 0).toDouble(),
      totalAllowances: (json['totalAllowances'] ?? 0).toDouble(),
      totalDeductions: (json['totalDeductions'] ?? 0).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'employee': employeeId,
      'basicSalary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'currency': currency,
      'effectiveDate': effectiveDate?.toIso8601String(),
      'notes': notes,
      'taxPercentage': taxPercentage,
      'insurancePercentage': insurancePercentage,
      'grossSalary': grossSalary,
      'netSalary': netSalary,
      'totalAllowances': totalAllowances,
      'totalDeductions': totalDeductions,
      'status': status,
    };
  }
} 