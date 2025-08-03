enum UserRole {
  admin,
  employee,
}

enum AppTheme {
  light,
  dark,
  system,
}

enum AppLanguage {
  english,
  nepali,
}

enum ApiStatus {
  initial,
  loading,
  success,
  error,
}

enum ValidationType {
  email,
  password,
  phone,
  required,
  minLength,
  maxLength,
  custom,
}

enum FileType {
  image,
  document,
  video,
  audio,
  other,
}

enum NotificationType {
  info,
  success,
  warning,
  error,
}

enum SortOrder {
  ascending,
  descending,
}

enum FilterType {
  date,
  status,
  category,
  priority,
  custom,
}

enum PaymentMethod {
  bankTransfer,
  cash,
  check,
  online,
}

enum AttendanceType {
  checkIn,
  checkOut,
  breakStart,
  breakEnd,
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

enum TaskStatus {
  todo,
  inProgress,
  completed,
  cancelled,
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

enum PayrollStatus {
  draft,
  approved,
  paid,
  cancelled,
}

enum SalaryComponent {
  basicSalary,
  housingAllowance,
  transportAllowance,
  mealAllowance,
  medicalAllowance,
  internetAllowance,
  phoneAllowance,
  otherAllowance,
}

enum DeductionType {
  incomeTax,
  insurance,
  providentFund,
  loan,
  other,
}

enum BankAccountType {
  savings,
  current,
  salary,
  other,
}

enum RequestType {
  leave,
  expense,
  equipment,
  training,
  other,
}

enum RequestStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.employee:
        return 'Employee';
    }
  }

  String get shortName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.employee:
        return 'Employee';
    }
  }
}

extension AppThemeExtension on AppTheme {
  String get displayName {
    switch (this) {
      case AppTheme.light:
        return 'Light';
      case AppTheme.dark:
        return 'Dark';
      case AppTheme.system:
        return 'System';
    }
  }
}

extension AppLanguageExtension on AppLanguage {
  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.nepali:
        return 'नेपाली';
    }
  }

  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.nepali:
        return 'ne';
    }
  }
}

extension ApiStatusExtension on ApiStatus {
  bool get isLoading => this == ApiStatus.loading;
  bool get isSuccess => this == ApiStatus.success;
  bool get isError => this == ApiStatus.error;
  bool get isInitial => this == ApiStatus.initial;
}

extension LeaveStatusExtension on LeaveStatus {
  String get displayName {
    switch (this) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
      case LeaveStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isPending => this == LeaveStatus.pending;
  bool get isApproved => this == LeaveStatus.approved;
  bool get isRejected => this == LeaveStatus.rejected;
  bool get isCancelled => this == LeaveStatus.cancelled;
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isTodo => this == TaskStatus.todo;
  bool get isInProgress => this == TaskStatus.inProgress;
  bool get isCompleted => this == TaskStatus.completed;
  bool get isCancelled => this == TaskStatus.cancelled;
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  bool get isLow => this == TaskPriority.low;
  bool get isMedium => this == TaskPriority.medium;
  bool get isHigh => this == TaskPriority.high;
  bool get isUrgent => this == TaskPriority.urgent;
}

extension PayrollStatusExtension on PayrollStatus {
  String get displayName {
    switch (this) {
      case PayrollStatus.draft:
        return 'Draft';
      case PayrollStatus.approved:
        return 'Approved';
      case PayrollStatus.paid:
        return 'Paid';
      case PayrollStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isDraft => this == PayrollStatus.draft;
  bool get isApproved => this == PayrollStatus.approved;
  bool get isPaid => this == PayrollStatus.paid;
  bool get isCancelled => this == PayrollStatus.cancelled;
} 