class BankAccount {
  final String id;
  final String employeeId;
  final String employeeName;
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String accountType;
  final String? routingNumber;
  final String? swiftCode;
  final String status;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  BankAccount({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.accountType,
    this.routingNumber,
    this.swiftCode,
    required this.status,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['_id'] ?? json['id'],
      employeeId: json['employee'] is String 
          ? json['employee'] 
          : json['employee']['_id'] ?? json['employee']['id'],
      employeeName: json['employee'] is String 
          ? json['employeeName'] ?? 'Unknown'
          : json['employee']['name'] ?? 'Unknown',
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountHolderName'],
      accountType: json['accountType'],
      routingNumber: json['routingNumber'],
      swiftCode: json['swiftCode'],
      status: json['status'] ?? 'active',
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      'accountType': accountType,
      'routingNumber': routingNumber,
      'swiftCode': swiftCode,
      'status': status,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BankAccount copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? accountType,
    String? routingNumber,
    String? swiftCode,
    String? status,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BankAccount(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountType: accountType ?? this.accountType,
      routingNumber: routingNumber ?? this.routingNumber,
      swiftCode: swiftCode ?? this.swiftCode,
      status: status ?? this.status,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 