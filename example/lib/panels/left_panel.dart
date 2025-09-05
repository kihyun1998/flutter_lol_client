import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../sections/connection_test_section.dart';
import '../sections/summoner_api_section.dart';

class LeftPanel extends StatelessWidget {
  final VoidCallback onTestConnection;
  final VoidCallback onGetCurrentSummoner;
  final VoidCallback onGetSummonerById;
  final TextEditingController summonerIdController;
  final bool isLoading;

  const LeftPanel({
    super.key,
    required this.onTestConnection,
    required this.onGetCurrentSummoner,
    required this.onGetSummonerById,
    required this.summonerIdController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          SectionHeader(
            icon: Icons.api,
            title: 'API Tests',
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          
          // Controls with ScrollView
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Connection Test Section
                  ConnectionTestSection(
                    onTestConnection: onTestConnection,
                    isLoading: isLoading,
                  ),

                  // Summoner API Section
                  SummonerApiSection(
                    onGetCurrentSummoner: onGetCurrentSummoner,
                    onGetSummonerById: onGetSummonerById,
                    summonerIdController: summonerIdController,
                    isLoading: isLoading,
                  ),

                  // Future API sections can be added here
                  // Match API, Champion API, etc.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}