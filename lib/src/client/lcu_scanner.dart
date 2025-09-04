import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:process/process.dart';

import '../exceptions/lcu_exceptions.dart';
import '../models/lcu_connection.dart';

/// Utility class for scanning and detecting League Client Update (LCU) API connections.
/// 
/// This class provides methods to automatically detect running League of Legends
/// clients and extract their LCU API connection information from lockfiles.
/// It supports both Windows and macOS platforms.
class LcuScanner {
  static const ProcessManager _processManager = LocalProcessManager();

  /// Scans for a running League of Legends client and returns connection information.
  /// 
  /// This method attempts multiple strategies to find the client:
  /// 1. First tries to find the client from running processes
  /// 2. Falls back to scanning common installation paths for lockfiles
  /// 
  /// Returns an [LcuConnection] object containing all necessary information
  /// to connect to the LCU API.
  /// 
  /// Throws [ClientNotRunningException] if no running client is found.
  /// Throws [LockfileNotFoundException] if lockfile cannot be found.
  /// Throws [InvalidLockfileException] if lockfile format is invalid.
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   final connection = await LcuScanner.scanForClient();
  ///   print('LCU API available at: ${connection.baseUrl}');
  /// } catch (e) {
  ///   print('League client not found: $e');
  /// }
  /// ```
  static Future<LcuConnection> scanForClient() async {
    try {
      // Try to find lockfile from running process first
      final connectionFromProcess = await _findFromRunningProcess();
      if (connectionFromProcess != null) {
        return connectionFromProcess;
      }

      // Fallback to scanning common installation paths
      final connectionFromPaths = await _findFromCommonPaths();
      if (connectionFromPaths != null) {
        return connectionFromPaths;
      }

      throw const ClientNotRunningException(
        'Could not find running League of Legends client. '
        'Please ensure the client is running and try again.',
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw ClientNotRunningException(
        'Failed to scan for League client: ${e.toString()}',
      );
    }
  }

  /// Attempts to scan for a League client without throwing exceptions.
  /// 
  /// This is a safe version of [scanForClient] that returns null instead
  /// of throwing exceptions when no client is found.
  /// 
  /// Returns an [LcuConnection] if a client is found, or null if no client
  /// is running or accessible.
  /// 
  /// Example:
  /// ```dart
  /// final connection = await LcuScanner.tryscanForClient();
  /// if (connection != null) {
  ///   print('Found client at: ${connection.baseUrl}');
  /// } else {
  ///   print('No client found');
  /// }
  /// ```
  static Future<LcuConnection?> tryscanForClient() async {
    try {
      return await scanForClient();
    } catch (e) {
      return null;
    }
  }

  /// Attempts to find LCU connection information from running League client processes.
  /// 
  /// This method checks for running League client processes on the current platform
  /// and extracts the installation path to locate the lockfile.
  /// 
  /// Returns an [LcuConnection] if found, or null if no running process is detected
  /// or if the lockfile cannot be accessed.
  static Future<LcuConnection?> _findFromRunningProcess() async {
    try {
      if (Platform.isWindows) {
        return await _findFromWindowsProcess();
      } else if (Platform.isMacOS) {
        return await _findFromMacOSProcess();
      }
    } catch (e) {
      // Ignore errors and try other methods
    }
    return null;
  }

  /// Windows-specific method to find League client process using WMI commands.
  /// 
  /// Uses the `wmic` command to query running LeagueClientUx.exe processes
  /// and extract their command line information to determine the installation path.
  /// 
  /// Returns an [LcuConnection] if the process is found and lockfile is readable,
  /// or null if the process is not running or lockfile is inaccessible.
  static Future<LcuConnection?> _findFromWindowsProcess() async {
    try {
      // Get process list with full command line
      final result = await _processManager.run([
        'wmic',
        'process',
        'where',
        'name="LeagueClientUx.exe"',
        'get',
        'CommandLine',
        '/format:csv',
      ]);

      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final lines = output.split('\n');

        for (final line in lines) {
          if (line.contains('LeagueClientUx.exe')) {
            // Extract installation directory from command line
            final regex = RegExp(r'"([^"]*LeagueClientUx\.exe)"');
            final match = regex.firstMatch(line);
            if (match != null) {
              final exePath = match.group(1)!;
              final installDir = path.dirname(exePath);
              final lockfilePath = path.join(installDir, 'lockfile');

              final connection = await _readLockfile(lockfilePath);
              if (connection != null) {
                return connection;
              }
            }
          }
        }
      }
    } catch (e) {
      // Continue to try other methods
    }
    return null;
  }

  /// macOS-specific method to find League client process using ps command.
  /// 
  /// Uses the `ps aux` command to find League client processes and extract
  /// the application path to locate the lockfile within the app bundle.
  /// 
  /// Returns an [LcuConnection] if the process is found and lockfile is readable,
  /// or null if the process is not running or lockfile is inaccessible.
  static Future<LcuConnection?> _findFromMacOSProcess() async {
    try {
      final result = await _processManager.run(['ps', 'aux']);

      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final lines = output.split('\n');

        for (final line in lines) {
          if (line.contains('LeagueClient')) {
            // Extract path from process line
            final parts = line.split(' ');
            for (int i = 0; i < parts.length; i++) {
              if (parts[i].contains('LeagueClient') &&
                  parts[i].contains('.app')) {
                final appPath = parts[i];
                final lockfilePath = path.join(
                  appPath,
                  'Contents',
                  'LoL',
                  'lockfile',
                );

                final connection = await _readLockfile(lockfilePath);
                if (connection != null) {
                  return connection;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      // Continue to try other methods
    }
    return null;
  }

  /// Attempts to find LCU connection by scanning common installation paths.
  /// 
  /// This fallback method checks predefined common installation directories
  /// for League of Legends and looks for lockfiles in those locations.
  /// 
  /// Returns an [LcuConnection] if a valid lockfile is found in any of the
  /// common paths, or null if no valid lockfile is found.
  static Future<LcuConnection?> _findFromCommonPaths() async {
    final commonPaths = _getCommonInstallPaths();

    for (final installPath in commonPaths) {
      final lockfilePath = path.join(installPath, 'lockfile');
      final connection = await _readLockfile(lockfilePath);
      if (connection != null) {
        return connection;
      }
    }

    return null;
  }

  /// Returns a list of common League of Legends installation directories.
  /// 
  /// The paths returned depend on the current platform:
  /// - Windows: Includes various drive letters and common game directories
  /// - macOS: Includes the standard Applications directory
  /// - Other platforms: Returns empty list
  /// 
  /// Returns a list of directory paths where League of Legends might be installed.
  static List<String> _getCommonInstallPaths() {
    if (Platform.isWindows) {
      return [
        r'C:\Riot Games\League of Legends',
        r'D:\Riot Games\League of Legends',
        r'E:\Riot Games\League of Legends',
        r'F:\Riot Games\League of Legends',
        r'C:\Games\League of Legends',
        r'D:\Games\League of Legends',
        r'C:\Program Files\Riot Games\League of Legends',
        r'C:\Program Files (x86)\Riot Games\League of Legends',
      ];
    } else if (Platform.isMacOS) {
      return ['/Applications/League of Legends.app/Contents/LoL'];
    }

    return [];
  }

  /// Reads and parses a lockfile from the specified path.
  /// 
  /// Attempts to read the lockfile at the given path and parse its contents
  /// using [parseLockfileContent].
  /// 
  /// Parameters:
  /// - [lockfilePath]: The full path to the lockfile
  /// 
  /// Returns an [LcuConnection] if the file exists and is valid,
  /// or null if the file doesn't exist or cannot be parsed.
  static Future<LcuConnection?> _readLockfile(String lockfilePath) async {
    try {
      final file = File(lockfilePath);
      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      return parseLockfileContent(content.trim());
    } catch (e) {
      return null;
    }
  }

  /// Parses lockfile content string into an [LcuConnection] object.
  /// 
  /// The lockfile format is: "LeagueClient:pid:port:password:https"
  /// where each component is separated by colons.
  /// 
  /// Parameters:
  /// - [content]: The raw lockfile content string
  /// 
  /// Returns an [LcuConnection] object with the parsed connection information.
  /// 
  /// Throws [InvalidLockfileException] if the content format is invalid
  /// or if the port number cannot be parsed.
  /// 
  /// This method is made public for testing purposes.
  /// 
  /// Example lockfile content: "LeagueClient:12345:54321:authToken123:https"
  static LcuConnection? parseLockfileContent(String content) {
    try {
      final parts = content.split(':');
      if (parts.length < 5) {
        throw const InvalidLockfileException(
          'Lockfile does not have expected format (expected 5 parts separated by :)',
        );
      }

      final port = int.tryParse(parts[2]);
      if (port == null) {
        throw const InvalidLockfileException('Invalid port number in lockfile');
      }

      return LcuConnection(
        host: '127.0.0.1',
        port: port,
        authToken: parts[3],
        protocol: parts[4],
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw InvalidLockfileException(
        'Failed to parse lockfile: ${e.toString()}',
      );
    }
  }
}
