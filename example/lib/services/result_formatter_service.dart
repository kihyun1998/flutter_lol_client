class ResultFormatterService {
  static ResultFormatterService? _instance;

  ResultFormatterService._();

  static ResultFormatterService get instance {
    _instance ??= ResultFormatterService._();
    return _instance!;
  }

  /// Format connection test result
  String formatConnectionResult(Map<String, dynamic> connectionData) {
    return '✅ Connection successful!\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
        'Host: ${connectionData['host']}\n'
        'Port: ${connectionData['port']}\n'
        'Protocol: ${connectionData['protocol']}\n'
        'Base URL: ${connectionData['baseUrl']}\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
  }

  /// Format connection error
  String formatConnectionError(String error) {
    return '❌ Connection failed:\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
        '$error';
  }

  /// Format summoner data result
  String formatSummonerResult(Map<String, dynamic> summonerData, {String? summonerId}) {
    final data = summonerData['data'];
    final title = summonerId != null 
        ? '👤 Summoner by ID ($summonerId)'
        : '👤 Current Summoner';
    
    return '$title\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
        '📛 Game Name: ${data['gameName']}\n'
        '🏷️ Display Name: ${data['displayName']}\n'
        '🏆 Tag Line: ${data['tagLine']}\n'
        '📊 Level: ${data['summonerLevel']}\n'
        '🔒 Privacy: ${data['privacy']}\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
        '🆔 Summoner ID: ${data['summonerId']}\n'
        '👥 Account ID: ${data['accountId']}\n'
        '🔑 PUUID: ${data['puuid']}\n'
        '🖼️ Profile Icon ID: ${data['profileIconId']}\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
        '📈 XP Current: ${data['xpSinceLastLevel']}\n'
        '🎯 XP to Next: ${data['xpUntilNextLevel']}\n'
        '📊 Progress: ${data['percentCompleteForNextLevel']}%\n'
        '🎲 Reroll Points: ${data['rerollPoints']['currentPoints']}/${data['rerollPoints']['maxRolls']}\n'
        '⚠️ Name Restrictions: ${data['hasNamingRestrictions']}';
  }

  /// Format API error result
  String formatApiError(String apiName, String error) {
    return '❌ $apiName failed:\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
        '$error';
  }

  /// Format loading message
  String formatLoadingMessage(String action) {
    return '🔍 $action...';
  }

  /// Format validation error
  String formatValidationError(String message) {
    return '⚠️ $message';
  }
}