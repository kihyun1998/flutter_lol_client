import '../../client/lcu_client.dart';
import '../../models/reroll_points.dart';
import '../../exceptions/lcu_exceptions.dart';

/// API client for game-related summoner functionality.
/// 
/// This class handles all game-specific summoner features including
/// reroll points, autofill settings, and other in-game mechanics.
class SummonerGameApi {
  final LcuClient _client;

  /// Creates a new [SummonerGameApi] instance with the provided LCU client.
  const SummonerGameApi(this._client);

  /// Retrieves the current summoner's reroll points.
  /// 
  /// Reroll points are used in ARAM mode to reroll champions.
  /// This endpoint provides current points and maximum capacity.
  /// 
  /// Returns a [RerollPoints] object with current and max reroll points.
  /// 
  /// Throws [ClientNotRunningException] if the League client is not running.
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final rerollPoints = await summonerGameApi.getCurrentSummonerRerollPoints();
  /// print('Current: ${rerollPoints.currentPoints}/${rerollPoints.maxRolls}');
  /// ```
  Future<RerollPoints> getCurrentSummonerRerollPoints() async {
    try {
      final response = await _client.get('/lol-summoner/v1/current-summoner/rerollPoints');
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

  /// Retrieves the current summoner's autofill settings.
  /// 
  /// Autofill is the system that assigns roles in ranked games when
  /// players don't get their preferred roles.
  /// 
  /// Returns a Map containing autofill-related information and settings.
  /// 
  /// Throws [ClientNotRunningException] if the League client is not running.
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final autofill = await summonerGameApi.getCurrentSummonerAutofill();
  /// print('Autofill data: $autofill');
  /// ```
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
}