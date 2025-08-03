import 'package:hready/core/error/app_exceptions.dart';
import 'package:hready/core/error/error_handler.dart';
import 'package:hready/core/error/result.dart';

/// A utility class for safely executing operations with proper error handling
class SafeExecutor {
  /// Execute a synchronous operation safely
  static Result<T> execute<T>(T Function() operation) {
    try {
      final result = operation();
      return Result.success(result);
    } catch (error) {
      final exception = ErrorHandler.handle(error);
      return Result.failure(exception);
    }
  }

  /// Execute an asynchronous operation safely
  static Future<Result<T>> executeAsync<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return Result.success(result);
    } catch (error) {
      final exception = ErrorHandler.handle(error);
      return Result.failure(exception);
    }
  }

  /// Execute an operation with timeout
  static Future<Result<T>> executeWithTimeout<T>(
    Future<T> Function() operation,
    Duration timeout,
  ) async {
    try {
      final result = await operation().timeout(timeout);
      return Result.success(result);
    } catch (error) {
      final exception = ErrorHandler.handle(error);
      return Result.failure(exception);
    }
  }

  /// Execute an operation with retry logic
  static Future<Result<T>> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(AppException)? shouldRetry,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        final result = await operation();
        return Result.success(result);
      } catch (error) {
        attempts++;
        final exception = ErrorHandler.handle(error);
        
        // Check if we should retry
        if (attempts >= maxRetries || (shouldRetry != null && !shouldRetry(exception))) {
          return Result.failure(exception);
        }
        
        // Wait before retrying
        if (attempts < maxRetries) {
          await Future.delayed(delay * attempts); // Exponential backoff
        }
      }
    }
    
    return Result.failure(const UnknownException('Max retries exceeded'));
  }

  /// Execute multiple operations and return the first successful result
  static Future<Result<T>> executeFirstSuccess<T>(
    List<Future<T> Function()> operations,
  ) async {
    final results = <Result<T>>[];
    
    for (final operation in operations) {
      final result = await executeAsync(operation);
      if (result.isSuccess) {
        return result;
      }
      results.add(result);
    }
    
    // Return the last error if all operations failed
    return results.last;
  }

  /// Execute multiple operations and return all results
  static Future<List<Result<T>>> executeAll<T>(
    List<Future<T> Function()> operations,
  ) async {
    final results = <Result<T>>[];
    
    for (final operation in operations) {
      final result = await executeAsync(operation);
      results.add(result);
    }
    
    return results;
  }

  /// Execute an operation with fallback
  static Future<Result<T>> executeWithFallback<T>(
    Future<T> Function() primaryOperation,
    Future<T> Function() fallbackOperation,
  ) async {
    final primaryResult = await executeAsync(primaryOperation);
    
    if (primaryResult.isSuccess) {
      return primaryResult;
    }
    
    return await executeAsync(fallbackOperation);
  }
}

/// Extension methods for Future to add safe execution
extension SafeExecutionExtension<T> on Future<T> {
  /// Execute this future safely with error handling
  Future<Result<T>> safe() async {
    return await SafeExecutor.executeAsync(() => this);
  }

  /// Execute this future with timeout
  Future<Result<T>> safeWithTimeout(Duration timeout) async {
    return await SafeExecutor.executeWithTimeout(() => this, timeout);
  }

  /// Execute this future with retry logic
  Future<Result<T>> safeWithRetry({
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(AppException)? shouldRetry,
  }) async {
    return await SafeExecutor.executeWithRetry(
      () => this,
      maxRetries: maxRetries,
      delay: delay,
      shouldRetry: shouldRetry,
    );
  }
}

/// Extension methods for synchronous operations
extension SafeExecutionSyncExtension<T> on T Function() {
  /// Execute this function safely with error handling
  Result<T> safe() {
    return SafeExecutor.execute(this);
  }
} 