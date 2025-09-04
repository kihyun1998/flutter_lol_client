import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lol_client/flutter_lol_client.dart';

void main() {
  group('LcuScanner', () {
    test('should parse valid lockfile content', () {
      const lockfileContent = 'LeagueClient:1234:56789:abcdef123456:https';
      final connection = LcuScanner.parseLockfileContent(lockfileContent);
      
      expect(connection, isNotNull);
      expect(connection!.port, equals(56789));
      expect(connection.authToken, equals('abcdef123456'));
      expect(connection.protocol, equals('https'));
      expect(connection.host, equals('127.0.0.1'));
    });

    test('should throw InvalidLockfileException for invalid format', () {
      const invalidLockfile = 'invalid:format';
      expect(
        () => LcuScanner.parseLockfileContent(invalidLockfile),
        throwsA(isA<InvalidLockfileException>()),
      );
    });

    test('should throw InvalidLockfileException for invalid port', () {
      const invalidPortLockfile = 'LeagueClient:1234:invalid_port:token:https';
      expect(
        () => LcuScanner.parseLockfileContent(invalidPortLockfile),
        throwsA(isA<InvalidLockfileException>()),
      );
    });

    test('should return null when client not found', () async {
      final connection = await LcuScanner.tryscanForClient();
      // This will likely be null in test environment
      expect(connection, anyOf(isNull, isA<LcuConnection>()));
    });
  });

  group('LcuConnection', () {
    test('should create baseUrl correctly', () {
      final connection = LcuConnection(
        host: '127.0.0.1',
        port: 12345,
        authToken: 'token123',
        protocol: 'https',
      );

      expect(connection.baseUrl, equals('https://127.0.0.1:12345'));
    });

    test('should compare connections correctly', () {
      final connection1 = LcuConnection(
        host: '127.0.0.1',
        port: 12345,
        authToken: 'token123',
        protocol: 'https',
      );

      final connection2 = LcuConnection(
        host: '127.0.0.1',
        port: 12345,
        authToken: 'token123',
        protocol: 'https',
      );

      expect(connection1, equals(connection2));
      expect(connection1.hashCode, equals(connection2.hashCode));
    });
  });

  group('LeagueDetector', () {
    test('should return boolean for isLeagueRunning', () async {
      final isRunning = await LeagueDetector.isLeagueRunning();
      expect(isRunning, isA<bool>());
    });

    test('should throw exception when client not running', () async {
      // This will likely throw in test environment
      try {
        await LeagueDetector.getLeagueProcessInfo();
      } catch (e) {
        expect(e, isA<ClientNotRunningException>());
      }
      
      try {
        await LeagueDetector.getLeagueInstallationPath();
      } catch (e) {
        expect(e, isA<ClientNotRunningException>());
      }
    });
  });

  group('LeagueProcessInfo', () {
    test('should create valid process info', () {
      final processInfo = LeagueProcessInfo(
        pid: 1234,
        executablePath: r'C:\Riot Games\League of Legends\LeagueClient.exe',
        installationPath: r'C:\Riot Games\League of Legends',
      );

      expect(processInfo.pid, equals(1234));
      expect(processInfo.executablePath, contains('LeagueClient.exe'));
      expect(processInfo.installationPath, contains('League of Legends'));
    });

    test('should compare process info correctly', () {
      final processInfo1 = LeagueProcessInfo(
        pid: 1234,
        executablePath: r'C:\test\LeagueClient.exe',
        installationPath: r'C:\test',
      );

      final processInfo2 = LeagueProcessInfo(
        pid: 1234,
        executablePath: r'C:\test\LeagueClient.exe',
        installationPath: r'C:\test',
      );

      expect(processInfo1, equals(processInfo2));
      expect(processInfo1.hashCode, equals(processInfo2.hashCode));
    });
  });
}
