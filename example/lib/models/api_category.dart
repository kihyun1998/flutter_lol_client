import 'package:flutter/material.dart';

enum ApiCategoryType {
  getCurrentSummoner,
  getSummonerById,
  getSummonerByPuuid,
  getCurrentSummonerIds,
  getCurrentSummonerJwt,
  getCurrentSummonerRerollPoints,
  getCurrentSummonerProfile,
  getCurrentSummonerPrivacy,
  checkNameAvailability,
  getSummonerServiceStatus,
  getCurrentSummonerAutofill,
  // Future endpoints can be added here
}

class ApiCategory {
  final ApiCategoryType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const ApiCategory({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  static const List<ApiCategory> categories = [
    ApiCategory(
      type: ApiCategoryType.getCurrentSummoner,
      name: 'GET /lol-summoner/v1/current-summoner',
      description: 'Returns information about the currently logged-in summoner',
      icon: Icons.person,
      color: Colors.green,
    ),
    ApiCategory(
      type: ApiCategoryType.getSummonerById,
      name: 'GET /lol-summoner/v1/summoners/{id}',
      description: 'Lookup summoner information by summoner ID',
      icon: Icons.search,
      color: Colors.green,
    ),
    ApiCategory(
      type: ApiCategoryType.getSummonerByPuuid,
      name: 'GET /lol-summoner/v1/summoners-by-puuid-cached/{puuid}',
      description: 'Lookup summoner information by PUUID (cached)',
      icon: Icons.person_search,
      color: Colors.green,
    ),
    ApiCategory(
      type: ApiCategoryType.getCurrentSummonerIds,
      name: 'GET /lol-summoner/v1/current-summoner/account-and-summoner-ids',
      description: 'Returns just the account ID and summoner ID (lightweight)',
      icon: Icons.badge,
      color: Colors.blue,
    ),
    ApiCategory(
      type: ApiCategoryType.getCurrentSummonerJwt,
      name: 'GET /lol-summoner/v1/current-summoner/jwt',
      description: 'Returns JWT token for the current summoner',
      icon: Icons.token,
      color: Colors.blue,
    ),
    ApiCategory(
      type: ApiCategoryType.getCurrentSummonerRerollPoints,
      name: 'GET /lol-summoner/v1/current-summoner/rerollPoints',
      description: 'Returns ARAM reroll points (used for champion rerolls)',
      icon: Icons.refresh,
      color: Colors.orange,
    ),
    ApiCategory(
      type: ApiCategoryType.getCurrentSummonerProfile,
      name: 'GET /lol-summoner/v1/summoner-profile',
      description: 'Returns general summoner profile information',
      icon: Icons.person_outline,
      color: Colors.purple,
    ),
    ApiCategory(
      type: ApiCategoryType.getCurrentSummonerPrivacy,
      name: 'GET /lol-summoner/v1/current-summoner/profile-privacy',
      description: 'Returns profile privacy settings for the current summoner',
      icon: Icons.privacy_tip,
      color: Colors.purple,
    ),
    ApiCategory(
      type: ApiCategoryType.checkNameAvailability,
      name: 'GET /lol-summoner/v1/check-name-availability/{name}',
      description: 'Checks if a summoner name is available for use',
      icon: Icons.check_circle,
      color: Colors.purple,
    ),
    ApiCategory(
      type: ApiCategoryType.getSummonerServiceStatus,
      name: 'GET /lol-summoner/v1/status',
      description: 'Returns the current status of the summoner service',
      icon: Icons.health_and_safety,
      color: Colors.blue,
    ),
    ApiCategory(
      type: ApiCategoryType.getCurrentSummonerAutofill,
      name: 'GET /lol-summoner/v1/current-summoner/autofill',
      description: 'Returns autofill protection and related settings',
      icon: Icons.auto_awesome,
      color: Colors.orange,
    ),
  ];

  static ApiCategory getByType(ApiCategoryType type) {
    return categories.firstWhere((category) => category.type == type);
  }
}