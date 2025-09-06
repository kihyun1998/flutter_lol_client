import 'package:flutter/material.dart';
import '../widgets/api_test_card.dart';
import '../widgets/action_button.dart';

class SummonerInfoSection extends StatelessWidget {
  final VoidCallback onGetCurrentSummoner;
  final VoidCallback onGetSummonerById;
  final TextEditingController summonerIdController;
  final bool isLoading;

  const SummonerInfoSection({
    super.key,
    required this.onGetCurrentSummoner,
    required this.onGetSummonerById,
    required this.summonerIdController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ApiTestCard(
      icon: Icons.person,
      title: '/lol-summoner/v1 - Basic Lookups',
      iconColor: Colors.green.shade400,
      children: [
        ActionButton(
          onPressed: onGetCurrentSummoner,
          icon: const Icon(Icons.account_circle),
          label: '/current-summoner',
          backgroundColor: Colors.green.shade600,
          isLoading: isLoading,
          tooltip: 'GET /lol-summoner/v1/current-summoner\n\nReturns information about the currently logged-in summoner',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: summonerIdController,
                decoration: InputDecoration(
                  labelText: 'Summoner ID',
                  hintText: 'Enter summoner ID',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => onGetSummonerById(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: isLoading ? null : onGetSummonerById,
              icon: const Icon(Icons.search),
              tooltip: 'GET /lol-summoner/v1/summoners/{id}\n\nLookup summoner by ID',
              style: IconButton.styleFrom(
                backgroundColor: Colors.green.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Available endpoints: /summoners/{id}, /summoners-by-puuid/{puuid}, /summoners-by-name/{name}',
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