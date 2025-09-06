import '../../client/lcu_client.dart';
import '../../models/summoner.dart';
import '../../exceptions/lcu_exceptions.dart';

/// API client for basic summoner information retrieval.
/// 
/// This class handles all summoner lookup and basic information
/// endpoints including current summoner and lookups by various identifiers.
class SummonerInfoApi {
  final LcuClient _client;

  /// Creates a new [SummonerInfoApi] instance with the provided LCU client.
  const SummonerInfoApi(this._client);

  /// Retrieves information about the currently logged-in summoner.
  /// 
  /// This method calls the `/lol-summoner/v1/current-summoner` endpoint
  /// to get detailed information about the summoner that is currently
  /// logged into the League client.
  /// 
  /// Returns a [Summoner] object containing all available information
  /// about the current summoner including name, level, IDs, and XP progress.
  /// 
  /// Throws [ClientNotRunningException] if the League client is not running.
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final connection = await LcuScanner.scanForClient();
  /// final client = LcuClient(connection);
  /// final summonerInfoApi = SummonerInfoApi(client);
  /// 
  /// try {
  ///   final summoner = await summonerInfoApi.getCurrentSummoner();
  ///   print('Current summoner: ${summoner.displayName} (Level ${summoner.summonerLevel})');
  /// } catch (e) {
  ///   print('Failed to get summoner info: $e');
  /// } finally {
  ///   client.close();
  /// }
  /// ```
  Future<Summoner> getCurrentSummoner() async {
    try {
      final response = await _client.get('/lol-summoner/v1/current-summoner');
      
      // Debug: Print the raw response for troubleshooting
      print('LCU Response for current summoner: $response');
      
      return Summoner.fromJson(response);
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuApiException(
        'Failed to get current summoner: ${e.toString()}',
        0, // Unknown status code for non-LCU exceptions
      );
    }
  }

  /// Retrieves summoner information by summoner ID.
  /// 
  /// Parameters:
  /// - [summonerId]: The unique summoner ID to look up
  /// 
  /// Returns a [Summoner] object with the requested summoner's information.
  /// 
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the summoner is not found or API returns an error.
  /// 
  /// Example:
  /// ```dart
  /// final summoner = await summonerInfoApi.getSummonerById(12345);
  /// print('Found summoner: ${summoner.displayName}');
  /// ```
  Future<Summoner> getSummonerById(int summonerId) async {
    try {
      final response = await _client.get('/lol-summoner/v1/summoners/$summonerId');
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

  /// Retrieves summoner information by PUUID.
  /// 
  /// The PUUID is Riot's universal unique identifier that works across
  /// all Riot games and regions.
  /// 
  /// Parameters:
  /// - [puuid]: The PUUID to look up
  /// 
  /// Returns a [Summoner] object with the requested summoner's information.
  /// 
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the summoner is not found or API returns an error.
  /// 
  /// Example:
  /// ```dart
  /// final summoner = await summonerInfoApi.getSummonerByPuuid('ABC123-DEF456...');
  /// print('Found summoner: ${summoner.displayName}');
  /// ```
  Future<Summoner> getSummonerByPuuid(String puuid) async {
    try {
      final response = await _client.get('/lol-summoner/v1/summoners-by-puuid/$puuid');
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
  /// Note: This endpoint may not be available in all regions or client versions.
  /// It's recommended to use PUUID or summoner ID when possible.
  /// 
  /// Parameters:
  /// - [name]: The summoner name to look up (case-insensitive)
  /// 
  /// Returns a [Summoner] object with the requested summoner's information.
  /// 
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the summoner is not found or API returns an error.
  /// 
  /// Example:
  /// ```dart
  /// final summoner = await summonerInfoApi.getSummonerByName('RiotPlayer');
  /// print('Found summoner: ${summoner.displayName}');
  /// ```
  Future<Summoner> getSummonerByName(String name) async {
    try {
      final response = await _client.get('/lol-summoner/v1/summoners-by-name/$name');
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
}