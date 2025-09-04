/// Contains information about a running League of Legends client process.
/// 
/// This class provides details about the League client process including
/// process ID, executable location, and installation directory.
class LeagueProcessInfo {
  /// The process ID (PID) of the running League client.
  /// 
  /// This unique identifier can be used to monitor or interact with
  /// the specific League client process.
  final int pid;
  
  /// The full path to the League client executable file.
  /// 
  /// This typically points to the LeagueClientUx.exe file in the
  /// League of Legends installation directory.
  final String executablePath;
  
  /// The root installation directory of League of Legends.
  /// 
  /// This is the directory containing the League client executable
  /// and other game files. Used to locate the lockfile and other
  /// client resources.
  final String installationPath;

  /// Creates a new [LeagueProcessInfo] instance.
  /// 
  /// All parameters are required:
  /// - [pid]: The process ID of the League client
  /// - [executablePath]: Full path to the executable file
  /// - [installationPath]: Root installation directory
  LeagueProcessInfo({
    required this.pid,
    required this.executablePath,
    required this.installationPath,
  });

  @override
  String toString() {
    return 'LeagueProcessInfo{pid: $pid, installationPath: $installationPath}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeagueProcessInfo &&
          runtimeType == other.runtimeType &&
          pid == other.pid &&
          executablePath == other.executablePath;

  @override
  int get hashCode => pid.hashCode ^ executablePath.hashCode;
}