import '../client/lcu_client.dart';
import '../exceptions/lcu_exceptions.dart';
import '../models/reroll_points.dart';
import '../models/summoner.dart';

/// API client for League of Legends summoner-related endpoints.
///
/// This class handles all /lol-summoner/* endpoints including current summoner
/// information, summoner lookups, profile management, and game-related features.
class LoLSummonerAPI {
  final LcuClient _client;

  /// Creates a new [LoLSummonerAPI] instance with the provided LCU client.
  const LoLSummonerAPI(this._client);

  // ============================================================================
  // CURRENT SUMMONER ENDPOINTS
  // ============================================================================

  /// Retrieves information about the currently logged-in summoner.
  ///
  /// Endpoint: GET /lol-summoner/v1/current-summoner
  Future<Summoner> getCurrentSummoner() async {
    try {
      final response = await _client.get('/lol-summoner/v1/current-summoner');
      print('LCU Response for current summoner: $response');
      return Summoner.fromJson(response);
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves the current summoner's account and summoner IDs only.
  ///
  /// Endpoint: GET /lol-summoner/v1/current-summoner/account-and-summoner-ids
  Future<Map<String, dynamic>> getCurrentSummonerIds() async {
    try {
      return await _client.get(
        '/lol-summoner/v1/current-summoner/account-and-summoner-ids',
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner IDs: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves the current summoner's JWT token.
  ///
  /// Endpoint: GET /lol-summoner/v1/current-summoner/jwt
  Future<String> getCurrentSummonerJwt() async {
    try {
      final response = await _client.get(
        '/lol-summoner/v1/current-summoner/jwt',
      );
      return response as String;
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner JWT: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves the current summoner's autofill settings.
  ///
  /// Endpoint: GET /lol-summoner/v1/current-summoner/autofill
  Future<Map<String, dynamic>> getCurrentSummonerAutofill() async {
    try {
      return await _client.get('/lol-summoner/v1/current-summoner/autofill');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner autofill: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves the current summoner's reroll points.
  ///
  /// Endpoint: GET /lol-summoner/v1/current-summoner/rerollPoints
  Future<RerollPoints> getCurrentSummonerRerollPoints() async {
    try {
      final response = await _client.get(
        '/lol-summoner/v1/current-summoner/rerollPoints',
      );
      return RerollPoints.fromJson(response);
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner reroll points: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves the current summoner's detailed summoner profile.
  ///
  /// Endpoint: GET /lol-summoner/v1/current-summoner/summoner-profile
  Future<Map<String, dynamic>> getCurrentSummonerDetailedProfile() async {
    try {
      return await _client.get(
        '/lol-summoner/v1/current-summoner/summoner-profile',
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner detailed profile: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves the current summoner's profile privacy settings.
  ///
  /// Endpoint: GET /lol-summoner/v1/current-summoner/profile-privacy
  Future<Map<String, dynamic>> getCurrentSummonerProfilePrivacy() async {
    try {
      return await _client.get(
        '/lol-summoner/v1/current-summoner/profile-privacy',
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner profile privacy: ${e.toString()}',
        0,
      );
    }
  }

  // ============================================================================
  // SUMMONER LOOKUP ENDPOINTS
  // ============================================================================

  /// Retrieves summoner information by summoner ID.
  ///
  /// Endpoint: GET /lol-summoner/v1/summoners/{id}
  Future<Summoner> getSummonerById(int summonerId) async {
    try {
      final response = await _client.get(
        '/lol-summoner/v1/summoners/$summonerId',
      );
      return Summoner.fromJson(response);
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get summoner by ID $summonerId: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves summoner information by PUUID (cached).
  ///
  /// Endpoint: GET /lol-summoner/v1/summoners-by-puuid-cached/{puuid}
  Future<Summoner> getSummonerByPuuid(String puuid) async {
    try {
      final response = await _client.get(
        '/lol-summoner/v1/summoners-by-puuid-cached/$puuid',
      );
      return Summoner.fromJson(response);
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get summoner by PUUID $puuid: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves summoner information by summoner name.
  ///
  /// Endpoint: GET /lol-summoner/v1/summoners-by-name/{name}
  Future<Summoner> getSummonerByName(String name) async {
    try {
      final response = await _client.get(
        '/lol-summoner/v1/summoners-by-name/$name',
      );
      return Summoner.fromJson(response);
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get summoner by name $name: ${e.toString()}',
        0,
      );
    }
  }

  // ============================================================================
  // PROFILE ENDPOINTS
  // ============================================================================

  /// Retrieves the current summoner's profile information.
  ///
  /// Endpoint: GET /lol-summoner/v1/summoner-profile
  Future<Map<String, dynamic>> getCurrentSummonerProfile() async {
    try {
      return await _client.get('/lol-summoner/v1/summoner-profile');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner profile: ${e.toString()}',
        0,
      );
    }
  }

  /// Checks if a summoner name is available for use.
  ///
  /// Endpoint: GET /lol-summoner/v1/check-name-availability/{name}
  Future<Map<String, dynamic>> checkNameAvailability(String name) async {
    try {
      return await _client.get(
        '/lol-summoner/v1/check-name-availability/$name',
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to check name availability for $name: ${e.toString()}',
        0,
      );
    }
  }

  /// Checks if profile privacy features are enabled in the client.
  ///
  /// Endpoint: GET /lol-summoner/v1/profile-privacy-enabled
  Future<dynamic> isProfilePrivacyEnabled() async {
    try {
      return await _client.get('/lol-summoner/v1/profile-privacy-enabled');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to check if profile privacy is enabled: ${e.toString()}',
        0,
      );
    }
  }

  // ============================================================================
  // V2 API ENDPOINTS
  // ============================================================================

  /// Retrieves available summoner icons (v2).
  ///
  /// Endpoint: GET /lol-summoner/v2/summoner-icons
  Future<List<Map<String, dynamic>>> getSummonerIcons() async {
    try {
      final response = await _client.get('/lol-summoner/v2/summoner-icons');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException('Failed to get summoner icons: ${e.toString()}', 0);
    }
  }

  /// Retrieves summoner names information (v2).
  ///
  /// Endpoint: GET /lol-summoner/v2/summoner-names
  Future<Map<String, dynamic>> getSummonerNames() async {
    try {
      return await _client.get('/lol-summoner/v2/summoner-names');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException('Failed to get summoner names: ${e.toString()}', 0);
    }
  }

  /// Retrieves multiple summoners information (v2).
  ///
  /// Endpoint: GET /lol-summoner/v2/summoners
  Future<List<Summoner>> getSummonersV2() async {
    try {
      final response = await _client.get('/lol-summoner/v2/summoners');
      return (response as List).map((json) => Summoner.fromJson(json)).toList();
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException('Failed to get summoners (v2): ${e.toString()}', 0);
    }
  }

  /// Retrieves summoner by PUUID (v2).
  ///
  /// Endpoint: GET /lol-summoner/v2/summoners/puuid/{puuid}
  Future<Summoner> getSummonerByPuuidV2(String puuid) async {
    try {
      final response = await _client.get(
        '/lol-summoner/v2/summoners/puuid/$puuid',
      );
      return Summoner.fromJson(response);
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get summoner by PUUID (v2): ${e.toString()}',
        0,
      );
    }
  }

  // ============================================================================
  // ADDITIONAL ENDPOINTS
  // ============================================================================

  /// Checks name availability for new summoners.
  ///
  /// Endpoint: GET /lol-summoner/v1/check-name-availability-new-summoners/{name}
  Future<Map<String, dynamic>> checkNameAvailabilityForNewSummoners(
    String name,
  ) async {
    try {
      return await _client.get(
        '/lol-summoner/v1/check-name-availability-new-summoners/$name',
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to check name availability for new summoners: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves alias lookup information.
  ///
  /// Endpoint: GET /lol-summoner/v1/alias/lookup
  Future<Map<String, dynamic>> getAliasLookup() async {
    try {
      return await _client.get('/lol-summoner/v1/alias/lookup');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException('Failed to get alias lookup: ${e.toString()}', 0);
    }
  }

  /// Retrieves player alias state.
  ///
  /// Endpoint: GET /lol-summoner/v1/player-alias-state
  Future<Map<String, dynamic>> getPlayerAliasState() async {
    try {
      return await _client.get('/lol-summoner/v1/player-alias-state');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get player alias state: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves player name mode.
  ///
  /// Endpoint: GET /lol-summoner/v1/player-name-mode
  Future<Map<String, dynamic>> getPlayerNameMode() async {
    try {
      return await _client.get('/lol-summoner/v1/player-name-mode');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get player name mode: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves Riot alias free eligibility.
  ///
  /// Endpoint: GET /lol-summoner/v1/riot-alias-free-eligibility
  Future<Map<String, dynamic>> getRiotAliasFreeEligibility() async {
    try {
      return await _client.get('/lol-summoner/v1/riot-alias-free-eligibility');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get Riot alias free eligibility: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves Riot alias purchase eligibility.
  ///
  /// Endpoint: GET /lol-summoner/v1/riot-alias-purchase-eligibility
  Future<Map<String, dynamic>> getRiotAliasPurchaseEligibility() async {
    try {
      return await _client.get(
        '/lol-summoner/v1/riot-alias-purchase-eligibility',
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get Riot alias purchase eligibility: ${e.toString()}',
        0,
      );
    }
  }

  // ============================================================================
  // SYSTEM ENDPOINTS
  // ============================================================================

  /// Retrieves the status of the summoner service.
  ///
  /// Endpoint: GET /lol-summoner/v1/status
  Future<Map<String, dynamic>> getSummonerServiceStatus() async {
    try {
      return await _client.get('/lol-summoner/v1/status');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get summoner service status: ${e.toString()}',
        0,
      );
    }
  }

  /// Retrieves information about whether summoner requests are ready.
  ///
  /// Endpoint: GET /lol-summoner/v1/summoner-requests-ready
  Future<dynamic> areSummonerRequestsReady() async {
    try {
      return await _client.get('/lol-summoner/v1/summoner-requests-ready');
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to check if summoner requests are ready: ${e.toString()}',
        0,
      );
    }
  }
}
