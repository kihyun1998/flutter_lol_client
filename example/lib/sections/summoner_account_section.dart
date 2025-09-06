import 'package:flutter/material.dart';
import '../widgets/api_test_card.dart';
import '../widgets/action_button.dart';

class SummonerAccountSection extends StatelessWidget {
  final VoidCallback onGetCurrentSummonerIds;
  final VoidCallback onGetSummonerServiceStatus;
  final bool isLoading;

  const SummonerAccountSection({
    super.key,
    required this.onGetCurrentSummonerIds,
    required this.onGetSummonerServiceStatus,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ApiTestCard(
      icon: Icons.account_box,
      title: '/lol-summoner/v1 - Account & System',
      iconColor: Colors.blue.shade400,
      children: [
        ActionButton(
          onPressed: onGetCurrentSummonerIds,
          icon: const Icon(Icons.badge),
          label: '/current-summoner/account-and-summoner-ids',
          backgroundColor: Colors.blue.shade600,
          isLoading: isLoading,
          tooltip: 'GET /lol-summoner/v1/current-summoner/account-and-summoner-ids\n\nReturns just the account ID and summoner ID (lightweight)',
        ),
        const SizedBox(height: 12),
        ActionButton(
          onPressed: onGetSummonerServiceStatus,
          icon: const Icon(Icons.health_and_safety),
          label: '/status',
          backgroundColor: Colors.blue.shade600,
          isLoading: isLoading,
          tooltip: 'GET /lol-summoner/v1/status\n\nReturns the current status of the summoner service',
        ),
        const SizedBox(height: 8),
        Text(
          'Available endpoints: /current-summoner/jwt, /summoner-requests-ready',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}