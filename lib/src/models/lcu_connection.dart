/// Represents connection information for the League Client Update (LCU) API.
/// 
/// This class contains all necessary information to connect to the LCU API
/// including host, port, authentication token, and protocol information.
/// The connection information is typically obtained from the League client's lockfile.
class LcuConnection {
  /// The hostname or IP address of the LCU API server.
  /// This is typically '127.0.0.1' for local connections.
  final String host;
  
  /// The port number on which the LCU API server is listening.
  /// This port is dynamically assigned when the League client starts.
  final int port;
  
  /// The authentication token required for LCU API requests.
  /// This token is used for basic authentication with the LCU API.
  final String authToken;
  
  /// The protocol used for LCU API communication.
  /// This is typically 'https' for secure connections.
  final String protocol;

  /// Creates a new [LcuConnection] instance with the provided connection details.
  /// 
  /// All parameters are required:
  /// - [host]: The hostname or IP address
  /// - [port]: The port number
  /// - [authToken]: The authentication token
  /// - [protocol]: The communication protocol (usually 'https')
  LcuConnection({
    required this.host,
    required this.port,
    required this.authToken,
    required this.protocol,
  });

  /// Returns the complete base URL for LCU API requests.
  /// 
  /// This combines the protocol, host, and port into a single URL string
  /// that can be used as the base for all LCU API endpoints.
  /// 
  /// Example: 'https://127.0.0.1:54321'
  String get baseUrl => '$protocol://$host:$port';

  @override
  String toString() {
    return 'LcuConnection{host: $host, port: $port, protocol: $protocol}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LcuConnection &&
          runtimeType == other.runtimeType &&
          host == other.host &&
          port == other.port &&
          authToken == other.authToken &&
          protocol == other.protocol;

  @override
  int get hashCode =>
      host.hashCode ^ port.hashCode ^ authToken.hashCode ^ protocol.hashCode;
}