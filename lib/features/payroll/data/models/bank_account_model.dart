import 'package:hready/features/payroll/domain/entities/bank_account.dart';

class BankAccountModel extends BankAccount {
  BankAccountModel({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    required super.bankName,
    required super.accountNumber,
    required super.accountHolderName,
    required super.accountType,
    super.routingNumber,
    super.swiftCode,
    required super.status,
    required super.isDefault,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
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

  factory BankAccountModel.fromEntity(BankAccount bankAccount) {
    return BankAccountModel(
      id: bankAccount.id,
      employeeId: bankAccount.employeeId,
      employeeName: bankAccount.employeeName,
      bankName: bankAccount.bankName,
      accountNumber: bankAccount.accountNumber,
      accountHolderName: bankAccount.accountHolderName,
      accountType: bankAccount.accountType,
      routingNumber: bankAccount.routingNumber,
      swiftCode: bankAccount.swiftCode,
      status: bankAccount.status,
      isDefault: bankAccount.isDefault,
      createdAt: bankAccount.createdAt,
      updatedAt: bankAccount.updatedAt,
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
} 