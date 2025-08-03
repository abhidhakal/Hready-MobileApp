class Salary {
  final String id;
  final String employeeId;
  final String employeeName;
  final double basicSalary;
  final Map<String, double> allowances;
  final Map<String, double> deductions;
  final String currency;
  final String status;
  final DateTime effectiveDate;
  final DateTime? endDate;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Computed properties
  double get totalAllowances => allowances.values.fold(0.0, (sum, value) => sum + value);
  double get totalDeductions => deductions.values.fold(0.0, (sum, value) => sum + value);
  double get grossSalary => basicSalary + totalAllowances;
  double get netSalary => grossSalary - totalDeductions;

  Salary({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.currency,
    required this.status,
    required this.effectiveDate,
    this.endDate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['_id'] ?? json['id'],
      employeeId: json['employee'] is String 
          ? json['employee'] 
          : json['employee']['_id'] ?? json['employee']['id'],
      employeeName: json['employee'] is String 
          ? json['employeeName'] ?? 'Unknown'
          : json['employee']['name'] ?? 'Unknown',
      basicSalary: (json['basicSalary'] ?? 0).toDouble(),
      allowances: Map<String, double>.from(json['allowances'] ?? {}),
      deductions: Map<String, double>.from(json['deductions'] ?? {}),
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

  Salary copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    double? basicSalary,
    Map<String, double>? allowances,
    Map<String, double>? deductions,
    String? currency,
    String? status,
    DateTime? effectiveDate,
    DateTime? endDate,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Salary(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      basicSalary: basicSalary ?? this.basicSalary,
      allowances: allowances ?? this.allowances,
      deductions: deductions ?? this.deductions,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      endDate: endDate ?? this.endDate,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 