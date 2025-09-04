class LcuConnection {
  final String host;
  final int port;
  final String authToken;
  final String protocol;

  LcuConnection({
    required this.host,
    required this.port,
    required this.authToken,
    required this.protocol,
  });

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