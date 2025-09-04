import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:process/process.dart';
import '../models/lcu_connection.dart';
import '../exceptions/lcu_exceptions.dart';

class LcuScanner {
  static const ProcessManager _processManager = LocalProcessManager();

  /// Scans for running League of Legends client and returns connection info
  /// Throws [ClientNotRunningException] if client is not found
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
        'Please ensure the client is running and try again.'
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw ClientNotRunningException(
        'Failed to scan for League client: ${e.toString()}'
      );
    }
  }

  /// Scans for client without throwing exceptions, returns null if not found
  static Future<LcuConnection?> tryscanForClient() async {
    try {
      return await scanForClient();
    } catch (e) {
      return null;
    }
  }

  /// Find LCU connection info from running LeagueClient process
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

  /// Windows: Use tasklist to find LeagueClient process and its path
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
        '/format:csv'
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

  /// macOS: Use ps to find LeagueClient process
  static Future<LcuConnection?> _findFromMacOSProcess() async {
    try {
      final result = await _processManager.run([
        'ps',
        'aux',
      ]);

      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final lines = output.split('\n');
        
        for (final line in lines) {
          if (line.contains('LeagueClient')) {
            // Extract path from process line
            final parts = line.split(' ');
            for (int i = 0; i < parts.length; i++) {
              if (parts[i].contains('LeagueClient') && parts[i].contains('.app')) {
                final appPath = parts[i];
                final lockfilePath = path.join(appPath, 'Contents', 'LoL', 'lockfile');
                
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

  /// Try common League of Legends installation paths
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

  /// Get list of common League of Legends installation paths
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
      return [
        '/Applications/League of Legends.app/Contents/LoL',
      ];
    }
    
    return [];
  }

  /// Read and parse lockfile content
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

  /// Parse lockfile content: "LeagueClient:pid:port:password:https"
  /// Made public for testing purposes
  static LcuConnection? parseLockfileContent(String content) {
    try {
      final parts = content.split(':');
      if (parts.length < 5) {
        throw const InvalidLockfileException(
          'Lockfile does not have expected format (expected 5 parts separated by :)'
        );
      }

      final port = int.tryParse(parts[2]);
      if (port == null) {
        throw const InvalidLockfileException(
          'Invalid port number in lockfile'
        );
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
        'Failed to parse lockfile: ${e.toString()}'
      );
    }
  }
}