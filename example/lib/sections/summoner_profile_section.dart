import 'package:flutter/material.dart';
import '../widgets/api_test_card.dart';
import '../widgets/action_button.dart';

class SummonerProfileSection extends StatelessWidget {
  final VoidCallback onGetCurrentSummonerProfile;
  final bool isLoading;

  const SummonerProfileSection({
    super.key,
    required this.onGetCurrentSummonerProfile,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ApiTestCard(
      icon: Icons.person_outline,
      title: '/lol-summoner/v1 - Profile Management',
      iconColor: Colors.purple.shade400,
      children: [
        ActionButton(
          onPressed: onGetCurrentSummonerProfile,
          icon: const Icon(Icons.description),
          label: '/summoner-profile',
          backgroundColor: Colors.purple.shade600,
          isLoading: isLoading,
          tooltip: 'GET /lol-summoner/v1/summoner-profile\n\nReturns general summoner profile information',
        ),
        const SizedBox(height: 8),
        Text(
          'Available endpoints: /current-summoner/summoner-profile, /current-summoner/profile-privacy, /check-name-availability/{name}, /profile-privacy-enabled',
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