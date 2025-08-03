import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hready/core/error/app_exceptions.dart';
import 'package:hready/core/widgets/app_snackbar.dart';
import 'package:hready/core/extensions/app_extensions.dart';

/// Centralized error handler for the application
class ErrorHandler {
  static AppException handle(dynamic error) {
    // Handle Dio errors (HTTP/Network errors)
    if (error is DioException) {
      return _handleDioError(error);
    }

    // Handle app exceptions
    if (error is AppException) {
      return error;
    }

    // Handle other exceptions
    if (error is Exception) {
      return UnknownException(
        error.toString(),
        originalError: error,
      );
    }

    // Handle any other type of error
    return UnknownException(
      error?.toString() ?? 'An unknown error occurred',
      originalError: error,
    );
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'Request timed out. Please check your connection and try again.',
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return ConnectionException(
          'No internet connection. Please check your network and try again.',
          originalError: error,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return BusinessException(
          'Request was cancelled.',
          originalError: error,
        );

      case DioExceptionType.unknown:
      default:
        return UnknownException(
          'An unexpected error occurred. Please try again.',
          originalError: error,
        );
    }
  }

  static AppException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // Handle different HTTP status codes
    switch (statusCode) {
      case 400:
        return _handleBadRequest(data, error);
      case 401:
        return UnauthorizedException(
          'Your session has expired. Please login again.',
          code: 'UNAUTHORIZED',
          originalError: error,
        );
      case 403:
        return PermissionException(
          'You don\'t have permission to perform this action.',
          code: 'FORBIDDEN',
          originalError: error,
        );
      case 404:
        return NotFoundException(
          'The requested resource was not found.',
          code: 'NOT_FOUND',
          originalError: error,
        );
      case 422:
        return _handleValidationError(data, error);
      case 500:
        return ServerException(
          'Server error. Please try again later.',
          statusCode: statusCode,
          originalError: error,
        );
      case 502:
      case 503:
      case 504:
        return ServerException(
          'Service temporarily unavailable. Please try again later.',
          statusCode: statusCode,
          originalError: error,
        );
      default:
        return ServerException(
          'An error occurred. Please try again.',
          statusCode: statusCode,
          originalError: error,
        );
    }
  }

  static AppException _handleBadRequest(dynamic data, DioException error) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'] ?? 'Invalid request';
      return BusinessException(
        message.toString(),
        code: 'BAD_REQUEST',
        originalError: error,
      );
    }
    return BusinessException(
      'Invalid request. Please check your input and try again.',
      code: 'BAD_REQUEST',
      originalError: error,
    );
  }

  static AppException _handleValidationError(dynamic data, DioException error) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? 'Validation failed';
      final errors = data['errors'] as Map<String, dynamic>?;
      
      Map<String, String>? fieldErrors;
      if (errors != null) {
        fieldErrors = errors.map((key, value) => MapEntry(
          key,
          value is List ? value.first.toString() : value.toString(),
        ));
      }

      return ValidationException(
        message.toString(),
        code: 'VALIDATION_ERROR',
        originalError: error,
        fieldErrors: fieldErrors,
      );
    }
    return ValidationException(
      'Please check your input and try again.',
      code: 'VALIDATION_ERROR',
      originalError: error,
    );
  }

  /// Show error message to user based on exception type
  static void showError(BuildContext context, AppException exception) {
    switch (exception.runtimeType) {
      case UnauthorizedException:
      case TokenExpiredException:
        context.showErrorSnackBar(
          exception.message,
          duration: const Duration(seconds: 5),
        );
        // Could trigger logout here
        break;
      case ValidationException:
        context.showWarningSnackBar(
          exception.message,
          duration: const Duration(seconds: 4),
        );
        break;
      case ConnectionException:
      case TimeoutException:
        context.showErrorSnackBar(
          exception.message,
          duration: const Duration(seconds: 4),
        );
        break;
      case ServerException:
        context.showErrorSnackBar(
          exception.message,
          duration: const Duration(seconds: 4),
        );
        break;
      case PermissionException:
        context.showWarningSnackBar(
          exception.message,
          duration: const Duration(seconds: 4),
        );
        break;
      default:
        context.showErrorSnackBar(
          exception.message,
          duration: const Duration(seconds: 3),
        );
    }
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(AppException exception) {
    switch (exception.runtimeType) {
      case UnauthorizedException:
      case TokenExpiredException:
        return 'Please login again to continue.';
      case ValidationException:
        return 'Please check your input and try again.';
      case ConnectionException:
        return 'No internet connection. Please check your network.';
      case TimeoutException:
        return 'Request timed out. Please try again.';
      case ServerException:
        return 'Server error. Please try again later.';
      case PermissionException:
        return 'You don\'t have permission for this action.';
      case NotFoundException:
        return 'The requested item was not found.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Log error for debugging (in production, this would send to a logging service)
  static void logError(AppException exception) {
    // In a real app, you'd send this to a logging service like Firebase Crashlytics
    print('ERROR: ${exception.toString()}');
    if (exception.originalError != null) {
      print('Original Error: ${exception.originalError}');
    }
  }
} 