/// Base exception class for LCU-related errors
abstract class LcuException implements Exception {
  final String message;
  final dynamic cause;

  const LcuException(this.message, [this.cause]);

  @override
  String toString() => 'LcuException: $message';
}

/// Exception thrown when League Client is not running
class ClientNotRunningException extends LcuException {
  const ClientNotRunningException([String? message])
      : super(message ?? 'League of Legends client is not running');

  @override
  String toString() => 'ClientNotRunningException: $message';
}

/// Exception thrown when lockfile cannot be found or read
class LockfileNotFoundException extends LcuException {
  const LockfileNotFoundException([String? message])
      : super(message ?? 'League client lockfile not found');

  @override
  String toString() => 'LockfileNotFoundException: $message';
}

/// Exception thrown when lockfile has invalid format
class InvalidLockfileException extends LcuException {
  const InvalidLockfileException([String? message])
      : super(message ?? 'Invalid lockfile format');

  @override
  String toString() => 'InvalidLockfileException: $message';
}

/// Exception thrown when connection to LCU API fails
class LcuConnectionException extends LcuException {
  final int? statusCode;

  const LcuConnectionException(String message, [this.statusCode, dynamic cause])
      : super(message, cause);

  @override
  String toString() {
    final status = statusCode != null ? ' (Status: $statusCode)' : '';
    return 'LcuConnectionException: $message$status';
  }
}

/// Exception thrown when LCU API returns an error
class LcuApiException extends LcuException {
  final int statusCode;
  final Map<String, dynamic>? errorDetails;

  const LcuApiException(String message, this.statusCode, [this.errorDetails])
      : super(message);

  @override
  String toString() {
    return 'LcuApiException: $message (Status: $statusCode)';
  }
}