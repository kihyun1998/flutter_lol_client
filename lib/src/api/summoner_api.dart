import '../client/lcu_client.dart';
import '../models/summoner.dart';
import '../exceptions/lcu_exceptions.dart';

/// API client for League of Legends summoner-related endpoints.
/// 
/// This class provides methods to interact with summoner data through
/// the LCU API, including getting current summoner information and
/// looking up other summoners by various identifiers.
class SummonerApi {
  final LcuClient _client;

  /// Creates a new [SummonerApi] instance with the provided LCU client.
  /// 
  /// Parameters:
  /// - [client]: The configured LCU client for making API requests
  const SummonerApi(this._client);

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
  /// final summonerApi = SummonerApi(client);
  /// 
  /// try {
  ///   final summoner = await summonerApi.getCurrentSummoner();
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
  /// final summoner = await summonerApi.getSummonerById(12345);
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
  /// final summoner = await summonerApi.getSummonerByPuuid('ABC123-DEF456...');
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
  /// final summoner = await summonerApi.getSummonerByName('RiotPlayer');
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

  /// Retrieves the current summoner's profile information.
  /// 
  /// This provides additional profile-specific information beyond
  /// the basic summoner data returned by [getCurrentSummoner].
  /// 
  /// Returns a Map containing profile information. The exact structure
  /// may vary depending on the client version and available data.
  /// 
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final profile = await summonerApi.getCurrentSummonerProfile();
  /// print('Profile data: $profile');
  /// ```
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
  /// This can be used to validate summoner names before attempting
  /// to change names or create accounts.
  /// 
  /// Parameters:
  /// - [name]: The summoner name to check
  /// 
  /// Returns a Map containing availability information and any validation
  /// messages from the server.
  /// 
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final availability = await summonerApi.checkNameAvailability('NewName');
  /// if (availability['available'] == true) {
  ///   print('Name is available!');
  /// }
  /// ```
  Future<Map<String, dynamic>> checkNameAvailability(String name) async {
    try {
      return await _client.get('/lol-summoner/v1/summoner-names/$name/availability');
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
}