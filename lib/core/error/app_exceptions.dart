/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException: $message';
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'NetworkException: $message';
}

class ConnectionException extends NetworkException {
  const ConnectionException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'ConnectionException: $message';
}

class TimeoutException extends NetworkException {
  const TimeoutException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Authentication related exceptions
class AuthenticationException extends AppException {
  const AuthenticationException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'AuthenticationException: $message';
}

class UnauthorizedException extends AuthenticationException {
  const UnauthorizedException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class TokenExpiredException extends AuthenticationException {
  const TokenExpiredException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'TokenExpiredException: $message';
}

/// Data related exceptions
class DataException extends AppException {
  const DataException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'DataException: $message';
}

class ValidationException extends DataException {
  final Map<String, String>? fieldErrors;

  const ValidationException(String message, {String? code, dynamic originalError, this.fieldErrors})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'ValidationException: $message';
}

class NotFoundException extends DataException {
  const NotFoundException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Server related exceptions
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(String message, {String? code, dynamic originalError, this.statusCode})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Business logic exceptions
class BusinessException extends AppException {
  const BusinessException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'BusinessException: $message';
}

/// Permission related exceptions
class PermissionException extends AppException {
  const PermissionException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'PermissionException: $message';
}

/// Unknown exceptions
class UnknownException extends AppException {
  const UnknownException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'UnknownException: $message';
} 