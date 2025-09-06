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
  String formatSummonerResult(Map<String, dynamic> summonerData, {String? summonerId, String? puuid}) {
    final data = summonerData['data'];
    String title;
    
    if (summonerId != null) {
      title = '👤 Summoner by ID ($summonerId)';
    } else if (puuid != null) {
      title = '👤 Summoner by PUUID (${puuid.length > 20 ? "${puuid.substring(0, 20)}..." : puuid})';
    } else {
      title = '👤 Current Summoner';
    }
    
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

  /// Format generic API result
  String formatApiResult(String title, Map<String, dynamic> data) {
    String result = '✅ $title\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';
    
    data.forEach((key, value) {
      result += '$key: $value\n';
    });
    
    return result.trim();
  }

  /// Format generic result with more flexible formatting
  String formatGenericResult(String title, Map<String, dynamic> result) {
    final data = result['data'];
    String output = '✅ $title\n'
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';
    
    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        output += '$key: $value\n';
      });
    } else {
      output += 'Data: $data\n';
    }
    
    return output.trim();
  }

}