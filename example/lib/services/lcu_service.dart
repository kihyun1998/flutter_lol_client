import 'package:flutter_lol_client/flutter_lol_client.dart';

class LcuConnectionResult {
  final String host;
  final int port;
  final String protocol;
  final String baseUrl;

  LcuConnectionResult({
    required this.host,
    required this.port,
    required this.protocol,
    required this.baseUrl,
  });
}

class LcuService {
  static LcuService? _instance;
  LcuClient? _client;

  LcuService._();

  static LcuService get instance {
    _instance ??= LcuService._();
    return _instance!;
  }

  /// Test LCU connection and return connection details
  Future<LcuConnectionResult> testConnection() async {
    try {
      final connection = await LcuScanner.scanForClient();
      return LcuConnectionResult(
        host: connection.host,
        port: connection.port,
        protocol: connection.protocol,
        baseUrl: connection.baseUrl,
      );
    } catch (e) {
      throw Exception('Failed to connect to League client: $e');
    }
  }

  /// Close current client connection
  void closeConnection() {
    _client?.close();
    _client = null;
  }

  /// Get current summoner information
  Future<Map<String, dynamic>> getCurrentSummoner() async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final summoner = await client.summoner.getCurrentSummoner();

      return {
        'success': true,
        'data': {
          'gameName': summoner.gameName,
          'displayName': summoner.displayName,
          'tagLine': summoner.tagLine,
          'summonerLevel': summoner.summonerLevel,
          'privacy': summoner.privacy,
          'summonerId': summoner.summonerId,
          'accountId': summoner.accountId,
          'puuid': summoner.puuid,
          'profileIconId': summoner.profileIconId,
          'xpSinceLastLevel': summoner.xpSinceLastLevel,
          'xpUntilNextLevel': summoner.xpUntilNextLevel,
          'percentCompleteForNextLevel': summoner.percentCompleteForNextLevel,
          'rerollPoints': {
            'currentPoints': summoner.rerollPoints.currentPoints,
            'maxRolls': summoner.rerollPoints.maxRolls,
          },
          'hasNamingRestrictions': summoner.hasNamingRestrictions,
        },
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }

  /// Get summoner by ID
  Future<Map<String, dynamic>> getSummonerById(int summonerId) async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final summoner = await client.summoner.getSummonerById(summonerId);

      return {
        'success': true,
        'data': {
          'gameName': summoner.gameName,
          'displayName': summoner.displayName,
          'tagLine': summoner.tagLine,
          'summonerLevel': summoner.summonerLevel,
          'privacy': summoner.privacy,
          'summonerId': summoner.summonerId,
          'accountId': summoner.accountId,
          'puuid': summoner.puuid,
          'profileIconId': summoner.profileIconId,
          'xpSinceLastLevel': summoner.xpSinceLastLevel,
          'xpUntilNextLevel': summoner.xpUntilNextLevel,
          'percentCompleteForNextLevel': summoner.percentCompleteForNextLevel,
          'rerollPoints': {
            'currentPoints': summoner.rerollPoints.currentPoints,
            'maxRolls': summoner.rerollPoints.maxRolls,
          },
          'hasNamingRestrictions': summoner.hasNamingRestrictions,
        },
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }


  /// Dispose service and cleanup resources
  void dispose() {
    closeConnection();
    _instance = null;
  }
}
