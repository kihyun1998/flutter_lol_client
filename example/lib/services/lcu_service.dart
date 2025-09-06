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

  /// Get current summoner's account and summoner IDs
  Future<Map<String, dynamic>> getCurrentSummonerIds() async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final ids = await client.summoner.getCurrentSummonerIds();

      return {
        'success': true,
        'data': ids,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }

  /// Get current summoner's reroll points
  Future<Map<String, dynamic>> getCurrentSummonerRerollPoints() async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final rerollPoints = await client.summoner.getCurrentSummonerRerollPoints();

      return {
        'success': true,
        'data': {
          'currentPoints': rerollPoints.currentPoints,
          'maxRolls': rerollPoints.maxRolls,
          'pointsToReroll': rerollPoints.pointsToReroll,
          'pointsCostToRoll': rerollPoints.pointsCostToRoll,
        },
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }

  /// Get current summoner's profile
  Future<Map<String, dynamic>> getCurrentSummonerProfile() async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final profile = await client.summoner.getCurrentSummonerProfile();

      return {
        'success': true,
        'data': profile,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }

  /// Get summoner service status
  Future<Map<String, dynamic>> getSummonerServiceStatus() async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final status = await client.summoner.getSummonerServiceStatus();

      return {
        'success': true,
        'data': status,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }

  /// Get current summoner's autofill settings
  Future<Map<String, dynamic>> getCurrentSummonerAutofill() async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final autofill = await client.summoner.getCurrentSummonerAutofill();

      return {
        'success': true,
        'data': autofill,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }

  /// Get summoner by PUUID
  Future<Map<String, dynamic>> getSummonerByPuuid(String puuid) async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final summoner = await client.summoner.getSummonerByPuuid(puuid);

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

  /// Get current summoner's JWT token
  Future<Map<String, dynamic>> getCurrentSummonerJwt() async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final jwt = await client.summoner.getCurrentSummonerJwt();

      return {
        'success': true,
        'data': {'jwt': jwt},
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }

  /// Get current summoner's profile privacy settings
  Future<Map<String, dynamic>> getCurrentSummonerProfilePrivacy() async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final privacy = await client.summoner.getCurrentSummonerProfilePrivacy();

      return {
        'success': true,
        'data': privacy,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      client?.close();
    }
  }

  /// Check summoner name availability
  Future<Map<String, dynamic>> checkNameAvailability(String name) async {
    LcuClient? client;
    try {
      client = await LcuClient.connect();
      final availability = await client.summoner.checkNameAvailability(name);

      return {
        'success': true,
        'data': availability,
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
