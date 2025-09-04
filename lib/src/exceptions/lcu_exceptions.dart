/// Base exception class for all League Client Update (LCU) related errors.
/// 
/// This abstract class serves as the foundation for all LCU-specific exceptions
/// in the flutter_lol_client package. It provides a common interface and
/// structure for error handling throughout the package.
/// 
/// All LCU exceptions include a descriptive message and an optional cause
/// for the underlying error.
abstract class LcuException implements Exception {
  /// A descriptive message explaining the error that occurred.
  final String message;
  
  /// The underlying cause of this exception, if any.
  /// 
  /// This can be another exception or any object that provides
  /// additional context about what caused this error.
  final dynamic cause;

  /// Creates a new [LcuException] with the given [message] and optional [cause].
  const LcuException(this.message, [this.cause]);

  @override
  String toString() => 'LcuException: $message';
}

/// Exception thrown when the League of Legends client is not running.
/// 
/// This exception is thrown by methods that require the League client to be
/// active, such as when trying to scan for LCU API connections or retrieve
/// process information.
/// 
/// Common scenarios that trigger this exception:
/// - Attempting to connect to LCU API when client is closed
/// - Trying to get process information when no League process is found
/// - Scanning for lockfiles when the client is not running
class ClientNotRunningException extends LcuException {
  const ClientNotRunningException([String? message])
    : super(message ?? 'League of Legends client is not running');

  @override
  String toString() => 'ClientNotRunningException: $message';
}

/// Exception thrown when the League client lockfile cannot be found or accessed.
/// 
/// The lockfile contains essential connection information for the LCU API,
/// including the port number and authentication token. This exception is thrown
/// when the file cannot be located or read.
/// 
/// Common causes:
/// - Lockfile doesn't exist in expected locations
/// - File permissions prevent reading the lockfile
/// - League client hasn't fully started yet (lockfile not created)
/// - League client installation is corrupted or incomplete
class LockfileNotFoundException extends LcuException {
  const LockfileNotFoundException([String? message])
    : super(message ?? 'League client lockfile not found');

  @override
  String toString() => 'LockfileNotFoundException: $message';
}

/// Exception thrown when the League client lockfile has an invalid format.
/// 
/// This exception occurs when the lockfile exists but its content doesn't
/// match the expected format. The lockfile should contain colon-separated
/// values in the format: "LeagueClient:pid:port:password:https"
/// 
/// Common causes:
/// - Lockfile is corrupted or partially written
/// - League client version uses a different lockfile format
/// - File was modified by another process
/// - Incomplete lockfile due to interrupted client startup
class InvalidLockfileException extends LcuException {
  const InvalidLockfileException([String? message])
    : super(message ?? 'Invalid lockfile format');

  @override
  String toString() => 'InvalidLockfileException: $message';
}

/// Exception thrown when connection to the LCU API fails.
/// 
/// This exception is thrown when there are network-level issues connecting
/// to the LCU API, such as connection timeouts, network errors, or when
/// the API server is not responding.
/// 
/// Common causes:
/// - Network connectivity issues
/// - LCU API server not responding
/// - Firewall blocking connections
/// - Invalid connection parameters
class LcuConnectionException extends LcuException {
  /// The HTTP status code associated with the connection failure, if any.
  /// 
  /// This will be null for network-level errors that don't involve HTTP responses.
  final int? statusCode;

  /// Creates a new [LcuConnectionException] with the given parameters.
  /// 
  /// Parameters:
  /// - [message]: Description of the connection error
  /// - [statusCode]: HTTP status code if applicable
  /// - [cause]: Underlying cause of the error
  const LcuConnectionException(super.message, [this.statusCode, super.cause]);

  @override
  String toString() {
    final status = statusCode != null ? ' (Status: $statusCode)' : '';
    return 'LcuConnectionException: $message$status';
  }
}

/// Exception thrown when the LCU API returns an error response.
/// 
/// This exception is thrown when the LCU API successfully receives a request
/// but returns an error status code or error response. This indicates that
/// the connection is working, but the API operation failed.
/// 
/// Common scenarios:
/// - Invalid API endpoints (404 Not Found)
/// - Authentication failures (401 Unauthorized)
/// - Rate limiting (429 Too Many Requests)
/// - Server errors (500 Internal Server Error)
/// - Invalid request parameters (400 Bad Request)
class LcuApiException extends LcuException {
  /// The HTTP status code returned by the LCU API.
  final int statusCode;
  
  /// Additional error details provided by the API response, if any.
  /// 
  /// This may contain structured error information from the LCU API
  /// that can help diagnose the specific issue.
  final Map<String, dynamic>? errorDetails;

  /// Creates a new [LcuApiException] with the given parameters.
  /// 
  /// Parameters:
  /// - [message]: Description of the API error
  /// - [statusCode]: HTTP status code from the API response
  /// - [errorDetails]: Additional error information from the API
  const LcuApiException(super.message, this.statusCode, [this.errorDetails]);

  @override
  String toString() {
    return 'LcuApiException: $message (Status: $statusCode)';
  }
}
