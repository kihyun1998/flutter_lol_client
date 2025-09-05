import 'package:flutter/material.dart';
import '../widgets/api_test_card.dart';
import '../widgets/action_button.dart';

class SummonerApiSection extends StatelessWidget {
  final VoidCallback onGetCurrentSummoner;
  final VoidCallback onGetSummonerById;
  final TextEditingController summonerIdController;
  final bool isLoading;

  const SummonerApiSection({
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
      title: 'Summoner API',
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
      ],
    );
  }
}