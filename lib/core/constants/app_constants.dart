class AppConstants {
  // App Information
  static const String appName = 'HReady';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'HR Management System';

  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const int apiTimeout = 30000; // 30 seconds
  static const int maxRetries = 3;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd MMM yyyy';
  static const String displayDateTimeFormat = 'dd MMM yyyy HH:mm';

  // Currency
  static const String defaultCurrency = 'Rs.';
  static const String currencyCode = 'NPR';

  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 4.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unauthorizedMessage = 'Unauthorized. Please login again.';
  static const String validationErrorMessage = 'Please check your input and try again.';

  // Success Messages
  static const String saveSuccessMessage = 'Saved successfully!';
  static const String deleteSuccessMessage = 'Deleted successfully!';
  static const String updateSuccessMessage = 'Updated successfully!';

  // Roles
  static const String adminRole = 'admin';
  static const String employeeRole = 'employee';

  // Status
  static const String activeStatus = 'active';
  static const String inactiveStatus = 'inactive';
  static const String pendingStatus = 'pending';
  static const String approvedStatus = 'approved';
  static const String rejectedStatus = 'rejected';

  // Payroll Status
  static const String draftStatus = 'draft';
  static const String paidStatus = 'paid';
  static const String cancelledStatus = 'cancelled';

  // Leave Types
  static const String annualLeave = 'annual';
  static const String sickLeave = 'sick';
  static const String personalLeave = 'personal';
  static const String maternityLeave = 'maternity';
  static const String paternityLeave = 'paternity';

  // Task Priority
  static const String lowPriority = 'low';
  static const String mediumPriority = 'medium';
  static const String highPriority = 'high';
  static const String urgentPriority = 'urgent';

  // Task Status
  static const String todoStatus = 'todo';
  static const String inProgressStatus = 'in_progress';
  static const String completedStatus = 'completed';
  static const String cancelledTaskStatus = 'cancelled';
} 