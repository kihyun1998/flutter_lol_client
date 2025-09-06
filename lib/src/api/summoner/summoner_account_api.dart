import '../../client/lcu_client.dart';
import '../../exceptions/lcu_exceptions.dart';

/// API client for summoner account and authentication related endpoints.
/// 
/// This class handles all account-related functionality including
/// IDs, JWT tokens, service status, and account management features.
class SummonerAccountApi {
  final LcuClient _client;

  /// Creates a new [SummonerAccountApi] instance with the provided LCU client.
  const SummonerAccountApi(this._client);

  /// Retrieves the current summoner's account and summoner IDs only.
  /// 
  /// This is a lightweight endpoint that returns only the essential ID information
  /// without all the additional summoner data. Useful when you only need the IDs.
  /// 
  /// Returns a Map containing accountId, summonerId, and potentially other ID fields.
  /// 
  /// Throws [ClientNotRunningException] if the League client is not running.
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final ids = await summonerAccountApi.getCurrentSummonerIds();
  /// print('Account ID: ${ids['accountId']}, Summoner ID: ${ids['summonerId']}');
  /// ```
  Future<Map<String, dynamic>> getCurrentSummonerIds() async {
    try {
      return await _client.get('/lol-summoner/v1/current-summoner/account-and-summoner-ids');
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
  /// The JWT token can be used for authentication with other Riot services
  /// or for advanced API operations that require token-based auth.
  /// 
  /// Returns a String containing the JWT token.
  /// 
  /// Throws [ClientNotRunningException] if the League client is not running.
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final jwt = await summonerAccountApi.getCurrentSummonerJwt();
  /// print('JWT: ${jwt.substring(0, 20)}...');
  /// ```
  Future<String> getCurrentSummonerJwt() async {
    try {
      final response = await _client.get('/lol-summoner/v1/current-summoner/jwt');
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

  /// Retrieves the status of the summoner service.
  /// 
  /// This endpoint provides information about whether the summoner service
  /// is available and operational within the League client.
  /// 
  /// Returns a Map containing service status information.
  /// 
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final status = await summonerAccountApi.getSummonerServiceStatus();
  /// print('Service status: $status');
  /// ```
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
  /// This endpoint indicates if the summoner system is ready to handle
  /// API requests, which can be useful for determining service availability.
  /// 
  /// Returns a Map or boolean indicating readiness status.
  /// 
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final ready = await summonerAccountApi.areSummonerRequestsReady();
  /// print('Requests ready: $ready');
  /// ```
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