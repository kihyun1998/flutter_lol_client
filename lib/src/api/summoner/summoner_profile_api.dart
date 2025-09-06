import '../../client/lcu_client.dart';
import '../../exceptions/lcu_exceptions.dart';

/// API client for summoner profile and privacy management.
/// 
/// This class handles all profile-related endpoints including
/// profile information, privacy settings, and name availability checking.
class SummonerProfileApi {
  final LcuClient _client;

  /// Creates a new [SummonerProfileApi] instance with the provided LCU client.
  const SummonerProfileApi(this._client);

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
  /// final profile = await summonerProfileApi.getCurrentSummonerProfile();
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

  /// Retrieves the current summoner's detailed summoner profile.
  /// 
  /// This endpoint provides more detailed profile information specific
  /// to the current summoner, including additional customization options.
  /// 
  /// Returns a Map containing detailed summoner profile information.
  /// 
  /// Throws [ClientNotRunningException] if the League client is not running.
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final profile = await summonerProfileApi.getCurrentSummonerDetailedProfile();
  /// print('Detailed profile: $profile');
  /// ```
  Future<Map<String, dynamic>> getCurrentSummonerDetailedProfile() async {
    try {
      return await _client.get('/lol-summoner/v1/current-summoner/summoner-profile');
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
  /// Privacy settings control what information about the summoner
  /// is visible to other players and external applications.
  /// 
  /// Returns a Map containing privacy setting information.
  /// 
  /// Throws [ClientNotRunningException] if the League client is not running.
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final privacy = await summonerProfileApi.getCurrentSummonerProfilePrivacy();
  /// print('Privacy settings: $privacy');
  /// ```
  Future<Map<String, dynamic>> getCurrentSummonerProfilePrivacy() async {
    try {
      return await _client.get('/lol-summoner/v1/current-summoner/profile-privacy');
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
  /// final availability = await summonerProfileApi.checkNameAvailability('NewName');
  /// if (availability['available'] == true) {
  ///   print('Name is available!');
  /// }
  /// ```
  Future<Map<String, dynamic>> checkNameAvailability(String name) async {
    try {
      return await _client.get('/lol-summoner/v1/check-name-availability/$name');
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
  /// This endpoint indicates whether the profile privacy system
  /// is available and active in the current client configuration.
  /// 
  /// Returns a Map or boolean indicating if privacy features are enabled.
  /// 
  /// Throws [LcuConnectionException] for connection-related errors.
  /// Throws [LcuApiException] if the API returns an error response.
  /// 
  /// Example:
  /// ```dart
  /// final privacyEnabled = await summonerProfileApi.isProfilePrivacyEnabled();
  /// print('Privacy enabled: $privacyEnabled');
  /// ```
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
}