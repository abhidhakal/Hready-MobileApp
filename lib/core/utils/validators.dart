// No imports needed for this file

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    return null;
  }

  static String? validateName(String? value, {String? fieldName}) {
    final required = validateRequired(value, fieldName: fieldName);
    if (required != null) return required;
    
    if (value!.length < 2) {
      return '${fieldName ?? 'Name'} must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return '${fieldName ?? 'Name'} must be less than 50 characters';
    }
    
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return '${fieldName ?? 'Name'} can only contain letters and spaces';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s-()]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  static String? validateNumeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a number';
    }
    
    return null;
  }

  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numeric = validateNumeric(value, fieldName: fieldName);
    if (numeric != null) return numeric;
    
    final number = double.parse(value!);
    if (number <= 0) {
      return '${fieldName ?? 'This field'} must be greater than 0';
    }
    
    return null;
  }

  static String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters long';
    }
    
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be less than $maxLength characters';
    }
    
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    
    try {
      Uri.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }

  static String? validateDate(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Date'} is required';
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }

  static String? validateFutureDate(String? value, {String? fieldName}) {
    final date = validateDate(value, fieldName: fieldName);
    if (date != null) return date;
    
    final selectedDate = DateTime.parse(value!);
    final now = DateTime.now();
    
    if (selectedDate.isBefore(now)) {
      return '${fieldName ?? 'Date'} must be in the future';
    }
    
    return null;
  }

  static String? validatePastDate(String? value, {String? fieldName}) {
    final date = validateDate(value, fieldName: fieldName);
    if (date != null) return date;
    
    final selectedDate = DateTime.parse(value!);
    final now = DateTime.now();
    
    if (selectedDate.isAfter(now)) {
      return '${fieldName ?? 'Date'} must be in the past';
    }
    
    return null;
  }

  static String? validateDateRange(String? startDate, String? endDate) {
    final start = validateDate(startDate, fieldName: 'Start date');
    if (start != null) return start;
    
    final end = validateDate(endDate, fieldName: 'End date');
    if (end != null) return end;
    
    final startDateTime = DateTime.parse(startDate!);
    final endDateTime = DateTime.parse(endDate!);
    
    if (endDateTime.isBefore(startDateTime)) {
      return 'End date must be after start date';
    }
    
    return null;
  }

  static String? validateFileSize(int? fileSize, int maxSizeInBytes) {
    if (fileSize == null) {
      return 'File size is required';
    }
    
    if (fileSize > maxSizeInBytes) {
      final maxSizeMB = (maxSizeInBytes / (1024 * 1024)).toStringAsFixed(1);
      return 'File size must be less than ${maxSizeMB}MB';
    }
    
    return null;
  }

  static String? validateFileType(String? fileName, List<String> allowedExtensions) {
    if (fileName == null || fileName.isEmpty) {
      return 'File name is required';
    }
    
    final extension = fileName.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      final allowed = allowedExtensions.join(', ');
      return 'File type must be one of: $allowed';
    }
    
    return null;
  }

  // Custom validator function
  static String? Function(String?) customValidator(String? Function(String?) validator) {
    return validator;
  }

  // Combine multiple validators
  static String? Function(String?) combineValidators(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}

// Form field validators for TextFormField
class FormValidators {
  static String? Function(String?) email = Validators.validateEmail;
  static String? Function(String?) password = Validators.validatePassword;
  static String? Function(String?) required = Validators.validateRequired;
  static String? Function(String?) name = Validators.validateName;
  static String? Function(String?) phone = Validators.validatePhone;
  static String? Function(String?) numeric = Validators.validateNumeric;
  static String? Function(String?) positiveNumber = Validators.validatePositiveNumber;
  static String? Function(String?) url = Validators.validateUrl;
  static String? Function(String?) date = Validators.validateDate;
  static String? Function(String?) futureDate = Validators.validateFutureDate;
  static String? Function(String?) pastDate = Validators.validatePastDate;

  static String? Function(String?) minLength(int length, {String? fieldName}) {
    return (String? value) => Validators.validateMinLength(value, length, fieldName: fieldName);
  }

  static String? Function(String?) maxLength(int length, {String? fieldName}) {
    return (String? value) => Validators.validateMaxLength(value, length, fieldName: fieldName);
  }

  static String? Function(String?) confirmPassword(String password) {
    return (String? value) => Validators.validateConfirmPassword(value, password);
  }

  static String? Function(String?) requiredField(String fieldName) {
    return (String? value) => Validators.validateRequired(value, fieldName: fieldName);
  }

  static String? Function(String?) nameField(String fieldName) {
    return (String? value) => Validators.validateName(value, fieldName: fieldName);
  }

  static String? Function(String?) numericField(String fieldName) {
    return (String? value) => Validators.validateNumeric(value, fieldName: fieldName);
  }

  static String? Function(String?) positiveNumberField(String fieldName) {
    return (String? value) => Validators.validatePositiveNumber(value, fieldName: fieldName);
  }
} 