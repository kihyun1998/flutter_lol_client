/// Represents a League of Legends summoner (player account).
/// 
/// This class contains all the information about a summoner that is
/// returned by the LCU API, including account details, level, experience,
/// and various identifiers used throughout the League client.
class Summoner {
  /// The account ID for this summoner.
  /// Used for some legacy API calls and match history.
  final int accountId;

  /// The display name of the summoner.
  /// This is the name that appears in game and in the client.
  final String displayName;

  /// The internal name used by the system.
  /// Usually the same as displayName but may differ in some cases.
  final String internalName;

  /// Indicates if the summoner name has been cleaned up by Riot's systems.
  /// This happens when inappropriate names are automatically changed.
  final bool nameChangeFlag;

  /// The percentage of XP progress towards the next level.
  /// Range: 0-100
  final int percentCompleteForNextLevel;

  /// The summoner's profile icon ID.
  /// Used to display the correct profile icon in the client.
  final int profileIconId;

  /// The Riot ID (new universal identifier).
  /// This is the unique identifier used across all Riot games.
  final String puuid;

  /// The number of times this summoner has been reported for various reasons.
  final int rerollPoints;

  /// The summoner's current level.
  /// Can be any value from 1 to the current level cap.
  final int summonerLevel;

  /// The unique summoner ID for this account.
  /// Used for most LCU API calls and as the primary identifier.
  final int summonerId;

  /// Indicates if this summoner account has been unnamed by Riot.
  /// This can happen due to policy violations or other administrative actions.
  final bool unnamed;

  /// The total XP earned by this summoner since account creation.
  /// This includes XP from all levels, not just current level progress.
  final int xpSinceLastLevel;

  /// The amount of XP needed to reach the next level.
  /// Combined with [xpSinceLastLevel] to calculate level progress.
  final int xpUntilNextLevel;

  /// Creates a new [Summoner] instance with the provided information.
  /// 
  /// All parameters represent data returned by the LCU API and should
  /// match the structure of the `/lol-summoner/v1/current-summoner` response.
  const Summoner({
    required this.accountId,
    required this.displayName,
    required this.internalName,
    required this.nameChangeFlag,
    required this.percentCompleteForNextLevel,
    required this.profileIconId,
    required this.puuid,
    required this.rerollPoints,
    required this.summonerLevel,
    required this.summonerId,
    required this.unnamed,
    required this.xpSinceLastLevel,
    required this.xpUntilNextLevel,
  });

  /// Creates a [Summoner] instance from a JSON map.
  /// 
  /// This factory constructor parses the JSON response from the LCU API
  /// and creates a properly typed Summoner object.
  /// 
  /// Parameters:
  /// - [json]: The JSON map containing summoner data from the API
  /// 
  /// Throws [FormatException] if required fields are missing or have
  /// incorrect types.
  /// 
  /// Example:
  /// ```dart
  /// final json = await lcuClient.get('/lol-summoner/v1/current-summoner');
  /// final summoner = Summoner.fromJson(json);
  /// ```
  factory Summoner.fromJson(Map<String, dynamic> json) {
    try {
      return Summoner(
        accountId: _parseIntFromJson(json, 'accountId'),
        displayName: _parseStringFromJson(json, 'displayName'),
        internalName: _parseStringFromJson(json, 'internalName'),
        nameChangeFlag: _parseBoolFromJson(json, 'nameChangeFlag'),
        percentCompleteForNextLevel: _parseIntFromJson(json, 'percentCompleteForNextLevel'),
        profileIconId: _parseIntFromJson(json, 'profileIconId'),
        puuid: _parseStringFromJson(json, 'puuid'),
        rerollPoints: _parseIntFromJson(json, 'rerollPoints'),
        summonerLevel: _parseIntFromJson(json, 'summonerLevel'),
        summonerId: _parseIntFromJson(json, 'summonerId'),
        unnamed: _parseBoolFromJson(json, 'unnamed'),
        xpSinceLastLevel: _parseIntFromJson(json, 'xpSinceLastLevel'),
        xpUntilNextLevel: _parseIntFromJson(json, 'xpUntilNextLevel'),
      );
    } catch (e) {
      throw FormatException('Failed to parse Summoner from JSON: ${e.toString()}\nJSON: $json');
    }
  }

  /// Safely parses an integer from JSON, handling various input types
  static int _parseIntFromJson(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      throw FormatException('Missing required field: $key');
    }
    
    if (value is int) {
      return value;
    } else if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed == null) {
        throw FormatException('Cannot parse "$value" as int for field $key');
      }
      return parsed;
    } else if (value is double) {
      return value.round();
    } else {
      throw FormatException('Invalid type for field $key: expected int, got ${value.runtimeType} ($value)');
    }
  }

  /// Safely parses a string from JSON
  static String _parseStringFromJson(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      throw FormatException('Missing required field: $key');
    }
    
    if (value is String) {
      return value;
    } else {
      return value.toString();
    }
  }

  /// Safely parses a boolean from JSON
  static bool _parseBoolFromJson(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      throw FormatException('Missing required field: $key');
    }
    
    if (value is bool) {
      return value;
    } else if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
      throw FormatException('Cannot parse "$value" as bool for field $key');
    } else if (value is int) {
      return value != 0;
    } else {
      throw FormatException('Invalid type for field $key: expected bool, got ${value.runtimeType} ($value)');
    }
  }

  /// Converts this [Summoner] instance to a JSON map.
  /// 
  /// Returns a map that can be serialized to JSON, matching the
  /// structure expected by the LCU API.
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'displayName': displayName,
      'internalName': internalName,
      'nameChangeFlag': nameChangeFlag,
      'percentCompleteForNextLevel': percentCompleteForNextLevel,
      'profileIconId': profileIconId,
      'puuid': puuid,
      'rerollPoints': rerollPoints,
      'summonerLevel': summonerLevel,
      'summonerId': summonerId,
      'unnamed': unnamed,
      'xpSinceLastLevel': xpSinceLastLevel,
      'xpUntilNextLevel': xpUntilNextLevel,
    };
  }

  /// Returns the total XP for the current level.
  /// 
  /// This is calculated as the sum of XP earned in the current level
  /// plus XP needed to complete the level.
  int get totalXpForCurrentLevel => xpSinceLastLevel + xpUntilNextLevel;

  /// Returns the percentage of XP progress towards next level as a double.
  /// 
  /// This provides a more precise percentage than [percentCompleteForNextLevel]
  /// which is rounded to an integer.
  double get precisePercentToNextLevel {
    if (totalXpForCurrentLevel == 0) return 0.0;
    return (xpSinceLastLevel / totalXpForCurrentLevel) * 100.0;
  }

  /// Returns true if this summoner account has any naming restrictions.
  /// 
  /// This includes both [nameChangeFlag] and [unnamed] status.
  bool get hasNamingRestrictions => nameChangeFlag || unnamed;

  @override
  String toString() {
    return 'Summoner{displayName: $displayName, level: $summonerLevel, '
           'summonerId: $summonerId, puuid: $puuid}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Summoner &&
          runtimeType == other.runtimeType &&
          summonerId == other.summonerId &&
          puuid == other.puuid;

  @override
  int get hashCode => summonerId.hashCode ^ puuid.hashCode;
}