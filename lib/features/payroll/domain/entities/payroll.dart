class Payroll {
  final String id;
  final String employeeId;
  final String employeeName;
  final int month;
  final int year;
  final double basicSalary;
  final Map<String, double> allowances;
  final Map<String, double> deductions;
  final Map<String, dynamic> overtime;
  final Map<String, double> bonuses;
  final Map<String, dynamic> leaves;
  final String currency;
  final String status;
  final DateTime? paymentDate;
  final String paymentMethod;
  final String? transactionId;
  final String? notes;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Computed properties
  double get totalAllowances => allowances.values.fold(0.0, (sum, value) => sum + value);
  double get totalDeductions => deductions.values.fold(0.0, (sum, value) => sum + value);
  double get totalBonuses => bonuses.values.fold(0.0, (sum, value) => sum + value);
  double get grossSalary => basicSalary + totalAllowances + (overtime['amount'] ?? 0.0) + totalBonuses;
  double get netSalary => grossSalary - totalDeductions - (leaves['deduction'] ?? 0.0);

  Payroll({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.month,
    required this.year,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.overtime,
    required this.bonuses,
    required this.leaves,
    required this.currency,
    required this.status,
    this.paymentDate,
    required this.paymentMethod,
    this.transactionId,
    this.notes,
    this.approvedBy,
    this.approvedAt,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payroll.fromJson(Map<String, dynamic> json) {
    return Payroll(
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

  Payroll copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    int? month,
    int? year,
    double? basicSalary,
    Map<String, double>? allowances,
    Map<String, double>? deductions,
    Map<String, dynamic>? overtime,
    Map<String, double>? bonuses,
    Map<String, dynamic>? leaves,
    String? currency,
    String? status,
    DateTime? paymentDate,
    String? paymentMethod,
    String? transactionId,
    String? notes,
    String? approvedBy,
    DateTime? approvedAt,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payroll(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      month: month ?? this.month,
      year: year ?? this.year,
      basicSalary: basicSalary ?? this.basicSalary,
      allowances: allowances ?? this.allowances,
      deductions: deductions ?? this.deductions,
      overtime: overtime ?? this.overtime,
      bonuses: bonuses ?? this.bonuses,
      leaves: leaves ?? this.leaves,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 