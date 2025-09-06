import '../client/lcu_client.dart';
import 'summoner/summoner_account_api.dart';
import 'summoner/summoner_game_api.dart';
import 'summoner/summoner_info_api.dart';
import 'summoner/summoner_profile_api.dart';

/// Main API client for League of Legends summoner-related endpoints.
///
/// This class serves as a facade that provides access to all summoner-related
/// functionality through specialized API clients organized by feature area.
///
/// The API is divided into logical groups:
/// - [info]: Basic summoner information and lookups
/// - [profile]: Profile management and privacy settings
/// - [account]: Account IDs, JWT tokens, and service status
/// - [game]: Game-related features like reroll points and autofill
class SummonerApi {
  final LcuClient _client;

  /// API client for basic summoner information and lookups
  late final SummonerInfoApi info;

  /// API client for profile management and privacy settings
  late final SummonerProfileApi profile;

  /// API client for account IDs, JWT tokens, and service status
  late final SummonerAccountApi account;

  /// API client for game-related features
  late final SummonerGameApi game;

  /// Creates a new [SummonerApi] instance with the provided LCU client.
  ///
  /// Parameters:
  /// - [client]: The configured LCU client for making API requests
  SummonerApi(this._client) {
    info = SummonerInfoApi(_client);
    profile = SummonerProfileApi(_client);
    account = SummonerAccountApi(_client);
    game = SummonerGameApi(_client);
  }

}
