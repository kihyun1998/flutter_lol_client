import 'package:flutter/material.dart';
import '../widgets/api_test_card.dart';
import '../widgets/action_button.dart';

class SummonerGameSection extends StatelessWidget {
  final VoidCallback onGetCurrentSummonerRerollPoints;
  final VoidCallback onGetCurrentSummonerAutofill;
  final bool isLoading;

  const SummonerGameSection({
    super.key,
    required this.onGetCurrentSummonerRerollPoints,
    required this.onGetCurrentSummonerAutofill,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ApiTestCard(
      icon: Icons.sports_esports,
      title: '/lol-summoner/v1/current-summoner - Game Features',
      iconColor: Colors.orange.shade400,
      children: [
        ActionButton(
          onPressed: onGetCurrentSummonerRerollPoints,
          icon: const Icon(Icons.refresh),
          label: '/rerollPoints',
          backgroundColor: Colors.orange.shade600,
          isLoading: isLoading,
          tooltip: 'GET /lol-summoner/v1/current-summoner/rerollPoints\n\nReturns ARAM reroll points (used for champion rerolls)',
        ),
        const SizedBox(height: 12),
        ActionButton(
          onPressed: onGetCurrentSummonerAutofill,
          icon: const Icon(Icons.auto_awesome),
          label: '/autofill',
          backgroundColor: Colors.orange.shade600,
          isLoading: isLoading,
          tooltip: 'GET /lol-summoner/v1/current-summoner/autofill\n\nReturns autofill protection and related settings',
        ),
        const SizedBox(height: 8),
        Text(
          'Available endpoints: /icon (PUT), /name (POST), /summoner-profile (GET/POST)',
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