import 'package:hready/core/error/app_exceptions.dart';

/// A wrapper class that represents either a success or failure result
sealed class Result<T> {
  const Result();

  /// Create a success result
  const factory Result.success(T data) = Success<T>;

  /// Create a failure result
  const factory Result.failure(AppException error) = Failure<T>;

  /// Check if the result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the data if successful, null otherwise
  T? get data => isSuccess ? (this as Success<T>).data : null;

  /// Get the error if failed, null otherwise
  AppException? get error => isFailure ? (this as Failure<T>).error : null;

  /// Transform the data if successful
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      return Result.success(transform((this as Success<T>).data));
    }
    return Result.failure((this as Failure<T>).error);
  }

  /// Transform the data if successful, or handle the error
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    if (isSuccess) {
      return transform((this as Success<T>).data);
    }
    return Result.failure((this as Failure<T>).error);
  }

  /// Execute a function if successful
  Result<T> onSuccess(void Function(T data) callback) {
    if (isSuccess) {
      callback((this as Success<T>).data);
    }
    return this;
  }

  /// Execute a function if failed
  Result<T> onFailure(void Function(AppException error) callback) {
    if (isFailure) {
      callback((this as Failure<T>).error);
    }
    return this;
  }

  /// Get the data or throw the error
  T getOrThrow() {
    if (isSuccess) {
      return (this as Success<T>).data;
    }
    throw (this as Failure<T>).error;
  }

  /// Get the data or a default value
  T getOrElse(T defaultValue) {
    if (isSuccess) {
      return (this as Success<T>).data;
    }
    return defaultValue;
  }

  /// Get the data or compute a default value
  T getOrElseGet(T Function() defaultValue) {
    if (isSuccess) {
      return (this as Success<T>).data;
    }
    return defaultValue();
  }
}

/// Success result
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Failure result
class Failure<T> extends Result<T> {
  final AppException error;

  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

/// Extension methods for Result
extension ResultExtensions<T> on Result<T> {
  /// Execute different functions based on success or failure
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(AppException error) onFailure,
  ) {
    if (isSuccess) {
      return onSuccess((this as Success<T>).data);
    }
    return onFailure((this as Failure<T>).error);
  }

  /// Execute a function if successful, return null if failed
  R? mapOrNull<R>(R Function(T data) transform) {
    if (isSuccess) {
      return transform((this as Success<T>).data);
    }
    return null;
  }

  /// Execute a function if successful, return default if failed
  R mapOrElse<R>(
    R Function(T data) transform,
    R Function(AppException error) onFailure,
  ) {
    if (isSuccess) {
      return transform((this as Success<T>).data);
    }
    return onFailure((this as Failure<T>).error);
  }
} 