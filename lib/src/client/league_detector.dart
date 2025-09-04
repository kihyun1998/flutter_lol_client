import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:process/process.dart';
import '../models/league_process_info.dart';
import '../exceptions/lcu_exceptions.dart';

class LeagueDetector {
  static const ProcessManager _processManager = LocalProcessManager();

  /// Check if League of Legends client is currently running
  static Future<bool> isLeagueRunning() async {
    try {
      final result = await _processManager.run([
        'tasklist',
        '/FI', 'IMAGENAME eq LeagueClient.exe',
        '/FO', 'CSV'
      ]);

      if (result.exitCode == 0) {
        final output = result.stdout as String;
        return output.contains('LeagueClient.exe');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get League of Legends installation path from running process
  /// Throws [ClientNotRunningException] if client is not running
  static Future<String> getLeagueInstallationPath() async {
    try {
      final result = await _processManager.run([
        'wmic',
        'process',
        'where',
        'name="LeagueClient.exe"',
        'get',
        'ExecutablePath',
        '/value'
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
        'League of Legends client is not running'
      );
    } catch (e) {
      if (e is ClientNotRunningException) {
        rethrow;
      }
      throw ClientNotRunningException(
        'Failed to get League installation path: ${e.toString()}'
      );
    }
  }

  /// Get detailed process information for running League client
  /// Throws [ClientNotRunningException] if client is not running
  static Future<LeagueProcessInfo> getLeagueProcessInfo() async {
    try {
      final result = await _processManager.run([
        'wmic',
        'process',
        'where',
        'name="LeagueClient.exe"',
        'get',
        'ProcessId,ExecutablePath',
        '/value'
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
        
        if (executablePath != null && pid != null && executablePath.isNotEmpty) {
          return LeagueProcessInfo(
            pid: pid,
            executablePath: executablePath,
            installationPath: path.dirname(executablePath),
          );
        }
      }

      throw const ClientNotRunningException(
        'League of Legends client is not running'
      );
    } catch (e) {
      if (e is ClientNotRunningException) {
        rethrow;
      }
      throw ClientNotRunningException(
        'Failed to get League process info: ${e.toString()}'
      );
    }
  }
}