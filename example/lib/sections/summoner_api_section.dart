import 'package:flutter/material.dart';
import '../widgets/api_test_card.dart';
import '../widgets/action_button.dart';

class SummonerApiSection extends StatelessWidget {
  final VoidCallback onGetCurrentSummoner;
  final VoidCallback onGetSummonerById;
  final VoidCallback onGetSummonerByPuuid;
  final VoidCallback onGetCurrentSummonerIds;
  final VoidCallback onGetCurrentSummonerRerollPoints;
  final VoidCallback onGetCurrentSummonerProfile;
  final VoidCallback onGetCurrentSummonerJwt;
  final VoidCallback onGetCurrentSummonerPrivacy;
  final VoidCallback onCheckNameAvailability;
  final VoidCallback onGetSummonerServiceStatus;
  final VoidCallback onGetCurrentSummonerAutofill;
  final TextEditingController summonerIdController;
  final TextEditingController puuidController;
  final TextEditingController nameController;
  final bool isLoading;

  const SummonerApiSection({
    super.key,
    required this.onGetCurrentSummoner,
    required this.onGetSummonerById,
    required this.onGetSummonerByPuuid,
    required this.onGetCurrentSummonerIds,
    required this.onGetCurrentSummonerRerollPoints,
    required this.onGetCurrentSummonerProfile,
    required this.onGetCurrentSummonerJwt,
    required this.onGetCurrentSummonerPrivacy,
    required this.onCheckNameAvailability,
    required this.onGetSummonerServiceStatus,
    required this.onGetCurrentSummonerAutofill,
    required this.summonerIdController,
    required this.puuidController,
    required this.nameController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summoner Info API
        ApiTestCard(
          icon: Icons.person,
          title: 'Summoner Info API',
          iconColor: Colors.green.shade400,
          children: [
            ActionButton(
              onPressed: onGetCurrentSummoner,
              icon: const Icon(Icons.account_circle),
              label: 'Get Current Summoner',
              backgroundColor: Colors.green.shade600,
              isLoading: isLoading,
              tooltip: 'GET /lol-summoner/v1/current-summoner',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: summonerIdController,
              decoration: InputDecoration(
                labelText: 'Summoner ID',
                hintText: 'Enter summoner ID',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                labelStyle: TextStyle(color: Colors.grey.shade400),
                hintStyle: TextStyle(color: Colors.grey.shade600),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: isLoading ? null : onGetSummonerById,
                  color: Theme.of(context).colorScheme.primary,
                  tooltip: 'GET /lol-summoner/v1/summoners/{summonerId}',
                ),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => onGetSummonerById(),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: puuidController,
              decoration: InputDecoration(
                labelText: 'PUUID',
                hintText: 'Enter PUUID',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                labelStyle: TextStyle(color: Colors.grey.shade400),
                hintStyle: TextStyle(color: Colors.grey.shade600),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: isLoading ? null : onGetSummonerByPuuid,
                  color: Theme.of(context).colorScheme.primary,
                  tooltip: 'GET /lol-summoner/v1/summoners-by-puuid-cached/{puuid}',
                ),
              ),
              onSubmitted: (_) => onGetSummonerByPuuid(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Summoner Account API
        ApiTestCard(
          icon: Icons.account_box,
          title: 'Summoner Account API',
          iconColor: Colors.blue.shade400,
          children: [
            ActionButton(
              onPressed: onGetCurrentSummonerIds,
              icon: const Icon(Icons.badge),
              label: 'Get Current Summoner IDs',
              backgroundColor: Colors.blue.shade600,
              isLoading: isLoading,
              tooltip: 'GET /lol-summoner/v1/current-summoner/account-and-summoner-ids',
            ),
            const SizedBox(height: 12),
            ActionButton(
              onPressed: onGetCurrentSummonerJwt,
              icon: const Icon(Icons.token),
              label: 'Get Current Summoner JWT',
              backgroundColor: Colors.blue.shade600,
              isLoading: isLoading,
              tooltip: 'GET /lol-summoner/v1/current-summoner/jwt',
            ),
            const SizedBox(height: 12),
            ActionButton(
              onPressed: onGetSummonerServiceStatus,
              icon: const Icon(Icons.health_and_safety),
              label: 'Get Service Status',
              backgroundColor: Colors.blue.shade600,
              isLoading: isLoading,
              tooltip: 'GET /lol-summoner/v1/status',
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Summoner Profile API
        ApiTestCard(
          icon: Icons.person_outline,
          title: 'Summoner Profile API',
          iconColor: Colors.purple.shade400,
          children: [
            ActionButton(
              onPressed: onGetCurrentSummonerProfile,
              icon: const Icon(Icons.description),
              label: 'Get Current Summoner Profile',
              backgroundColor: Colors.purple.shade600,
              isLoading: isLoading,
              tooltip: 'GET /lol-summoner/v1/summoner-profile',
            ),
            const SizedBox(height: 12),
            ActionButton(
              onPressed: onGetCurrentSummonerPrivacy,
              icon: const Icon(Icons.privacy_tip),
              label: 'Get Profile Privacy Settings',
              backgroundColor: Colors.purple.shade600,
              isLoading: isLoading,
              tooltip: 'GET /lol-summoner/v1/current-summoner/profile-privacy',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Summoner Name',
                hintText: 'Enter summoner name to check',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                labelStyle: TextStyle(color: Colors.grey.shade400),
                hintStyle: TextStyle(color: Colors.grey.shade600),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check_circle),
                  onPressed: isLoading ? null : onCheckNameAvailability,
                  color: Theme.of(context).colorScheme.primary,
                  tooltip: 'GET /lol-summoner/v1/check-name-availability/{name}',
                ),
              ),
              onSubmitted: (_) => onCheckNameAvailability(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Summoner Game API
        ApiTestCard(
          icon: Icons.sports_esports,
          title: 'Summoner Game API',
          iconColor: Colors.orange.shade400,
          children: [
            ActionButton(
              onPressed: onGetCurrentSummonerRerollPoints,
              icon: const Icon(Icons.refresh),
              label: 'Get Reroll Points',
              backgroundColor: Colors.orange.shade600,
              isLoading: isLoading,
              tooltip: 'GET /lol-summoner/v1/current-summoner/rerollPoints',
            ),
            const SizedBox(height: 12),
            ActionButton(
              onPressed: onGetCurrentSummonerAutofill,
              icon: const Icon(Icons.auto_awesome),
              label: 'Get Autofill Settings',
              backgroundColor: Colors.orange.shade600,
              isLoading: isLoading,
              tooltip: 'GET /lol-summoner/v1/current-summoner/autofill',
            ),
          ],
        ),
      ],
    );
  }
}