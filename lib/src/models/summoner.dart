import 'reroll_points.dart';

class Summoner {
  final int accountId;
  final String displayName;
  final String gameName;
  final String internalName;
  final bool nameChangeFlag;
  final int percentCompleteForNextLevel;
  final String privacy;
  final int profileIconId;
  final String puuid;
  final RerollPoints rerollPoints;
  final int summonerId;
  final int summonerLevel;
  final String tagLine;
  final bool unnamed;
  final int xpSinceLastLevel;
  final int xpUntilNextLevel;

  const Summoner({
    required this.accountId,
    required this.displayName,
    required this.gameName,
    required this.internalName,
    required this.nameChangeFlag,
    required this.percentCompleteForNextLevel,
    required this.privacy,
    required this.profileIconId,
    required this.puuid,
    required this.rerollPoints,
    required this.summonerId,
    required this.summonerLevel,
    required this.tagLine,
    required this.unnamed,
    required this.xpSinceLastLevel,
    required this.xpUntilNextLevel,
  });

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      accountId: json['accountId'] as int,
      displayName: json['displayName'] as String,
      gameName: json['gameName'] as String,
      internalName: json['internalName'] as String,
      nameChangeFlag: json['nameChangeFlag'] as bool,
      percentCompleteForNextLevel: json['percentCompleteForNextLevel'] as int,
      privacy: json['privacy'] as String,
      profileIconId: json['profileIconId'] as int,
      puuid: json['puuid'] as String,
      rerollPoints: RerollPoints.fromJson(json['rerollPoints'] as Map<String, dynamic>),
      summonerId: json['summonerId'] as int,
      summonerLevel: json['summonerLevel'] as int,
      tagLine: json['tagLine'] as String,
      unnamed: json['unnamed'] as bool,
      xpSinceLastLevel: json['xpSinceLastLevel'] as int,
      xpUntilNextLevel: json['xpUntilNextLevel'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'displayName': displayName,
      'gameName': gameName,
      'internalName': internalName,
      'nameChangeFlag': nameChangeFlag,
      'percentCompleteForNextLevel': percentCompleteForNextLevel,
      'privacy': privacy,
      'profileIconId': profileIconId,
      'puuid': puuid,
      'rerollPoints': rerollPoints.toJson(),
      'summonerId': summonerId,
      'summonerLevel': summonerLevel,
      'tagLine': tagLine,
      'unnamed': unnamed,
      'xpSinceLastLevel': xpSinceLastLevel,
      'xpUntilNextLevel': xpUntilNextLevel,
    };
  }

  int get totalXpForCurrentLevel => xpSinceLastLevel + xpUntilNextLevel;

  double get precisePercentToNextLevel {
    if (totalXpForCurrentLevel == 0) return 0.0;
    return (xpSinceLastLevel / totalXpForCurrentLevel) * 100.0;
  }

  bool get hasNamingRestrictions => nameChangeFlag || unnamed;

  @override
  String toString() {
    return 'Summoner{gameName: $gameName, displayName: $displayName, level: $summonerLevel, summonerId: $summonerId}';
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