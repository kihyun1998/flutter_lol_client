import 'package:path/path.dart' as path;
import 'package:process/process.dart';

import '../exceptions/lcu_exceptions.dart';
import '../models/league_process_info.dart';

/// Utility class for detecting and gathering information about League of Legends client processes.
/// 
/// This class provides methods to check if the League client is running,
/// get installation paths, and retrieve detailed process information.
/// Currently supports Windows platform using system commands.
class LeagueDetector {
  static const ProcessManager _processManager = LocalProcessManager();

  /// Checks if the League of Legends client is currently running.
  /// 
  /// This method uses the Windows `tasklist` command to search for the
  /// LeagueClientUx.exe process. It's designed to work on Windows systems.
  /// 
  /// Returns `true` if the League client process is found running,
  /// `false` otherwise.
  /// 
  /// Example:
  /// ```dart
  /// final isRunning = await LeagueDetector.isLeagueRunning();
  /// if (isRunning) {
  ///   print('League client is running!');
  /// } else {
  ///   print('League client is not running.');
  /// }
  /// ```
  static Future<bool> isLeagueRunning() async {
    try {
      final result = await _processManager.run([
        'tasklist',
        '/FI',
        'IMAGENAME eq LeagueClientUx.exe',
        '/FO',
        'CSV',
      ]);

      if (result.exitCode == 0) {
        final output = result.stdout as String;
        return output.contains('LeagueClientUx.exe');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the League of Legends installation path from the running process.
  /// 
  /// This method uses Windows WMI commands to query the running LeagueClientUx.exe
  /// process and extract its executable path, then returns the directory containing
  /// the executable.
  /// 
  /// Returns the full path to the League of Legends installation directory.
  /// 
  /// Throws [ClientNotRunningException] if the League client is not currently running
  /// or if the process information cannot be retrieved.
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   final installPath = await LeagueDetector.getLeagueInstallationPath();
  ///   print('League installed at: $installPath');
  /// } catch (e) {
  ///   print('Could not get installation path: $e');
  /// }
  /// ```
  static Future<String> getLeagueInstallationPath() async {
    try {
      final result = await _processManager.run([
        'wmic',
        'process',
        'where',
        'name="LeagueClientUx.exe"',
        'get',
        'ExecutablePath',
        '/value',
      ]);

      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final pathMatch = RegExp(r'ExecutablePath=(.+)').firstMatch(output);

        if (pathMatch != null) {
          final executablePath = pathMatch.group(1)!.trim();
          if (executablePath.isNotEmpty) {
            return path.dirname(executablePath);
          }
        }
      }

      throw const ClientNotRunningException(
        'League of Legends client is not running',
      );
    } catch (e) {
      if (e is ClientNotRunningException) {
        rethrow;
      }
      throw ClientNotRunningException(
        'Failed to get League installation path: ${e.toString()}',
      );
    }
  }

  /// Retrieves detailed process information for the running League client.
  /// 
  /// This method queries the system for comprehensive information about the
  /// League client process, including process ID, executable path, and
  /// installation directory.
  /// 
  /// Returns a [LeagueProcessInfo] object containing:
  /// - Process ID (PID)
  /// - Full path to the executable file
  /// - Installation directory path
  /// 
  /// Throws [ClientNotRunningException] if the League client is not currently
  /// running or if process information cannot be retrieved.
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   final processInfo = await LeagueDetector.getLeagueProcessInfo();
  ///   print('Process ID: ${processInfo.pid}');
  ///   print('Executable: ${processInfo.executablePath}');
  ///   print('Installation: ${processInfo.installationPath}');
  /// } catch (e) {
  ///   print('Could not get process info: $e');
  /// }
  /// ```
  static Future<LeagueProcessInfo> getLeagueProcessInfo() async {
    try {
      final result = await _processManager.run([
        'wmic',
        'process',
        'where',
        'name="LeagueClientUx.exe"',
        'get',
        'ProcessId,ExecutablePath',
        '/value',
      ]);

      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final lines = output.split('\n');

        String? executablePath;
        int? pid;

        for (final line in lines) {
          final execMatch = RegExp(r'ExecutablePath=(.+)').firstMatch(line);
          if (execMatch != null) {
            executablePath = execMatch.group(1)!.trim();
          }

          final pidMatch = RegExp(r'ProcessId=(.+)').firstMatch(line);
          if (pidMatch != null) {
            pid = int.tryParse(pidMatch.group(1)!.trim());
          }
        }

        if (executablePath != null &&
            pid != null &&
            executablePath.isNotEmpty) {
          return LeagueProcessInfo(
            pid: pid,
            executablePath: executablePath,
            installationPath: path.dirname(executablePath),
          );
        }
      }

      throw const ClientNotRunningException(
        'League of Legends client is not running',
      );
    } catch (e) {
      if (e is ClientNotRunningException) {
        rethrow;
      }
      throw ClientNotRunningException(
        'Failed to get League process info: ${e.toString()}',
      );
    }
  }
}
