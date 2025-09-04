class LeagueProcessInfo {
  final int pid;
  final String executablePath;
  final String installationPath;

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