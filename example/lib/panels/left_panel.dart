import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../sections/connection_test_section.dart';
import '../sections/api_category_selector.dart';
import '../models/api_category.dart';

class LeftPanel extends StatelessWidget {
  final VoidCallback onTestConnection;
  final ApiCategoryType selectedCategory;
  final ValueChanged<ApiCategoryType?> onCategoryChanged;
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

  const LeftPanel({
    super.key,
    required this.onTestConnection,
    required this.selectedCategory,
    required this.onCategoryChanged,
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
            title: 'LCU API Endpoints',
            iconColor: Theme.of(context).colorScheme.primary,
          ),
          
          // Controls with ScrollView
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32, // padding
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                  // Connection Test Section
                  ConnectionTestSection(
                    onTestConnection: onTestConnection,
                    isLoading: isLoading,
                  ),

                  // API Category Selector
                  ApiCategorySelector(
                    selectedCategory: selectedCategory,
                    onCategoryChanged: onCategoryChanged,
                    onGetCurrentSummoner: onGetCurrentSummoner,
                    onGetSummonerById: onGetSummonerById,
                    onGetSummonerByPuuid: onGetSummonerByPuuid,
                    onGetCurrentSummonerIds: onGetCurrentSummonerIds,
                    onGetCurrentSummonerRerollPoints: onGetCurrentSummonerRerollPoints,
                    onGetCurrentSummonerProfile: onGetCurrentSummonerProfile,
                    onGetCurrentSummonerJwt: onGetCurrentSummonerJwt,
                    onGetCurrentSummonerPrivacy: onGetCurrentSummonerPrivacy,
                    onCheckNameAvailability: onCheckNameAvailability,
                    onGetSummonerServiceStatus: onGetSummonerServiceStatus,
                    onGetCurrentSummonerAutofill: onGetCurrentSummonerAutofill,
                    summonerIdController: summonerIdController,
                    puuidController: puuidController,
                    nameController: nameController,
                    isLoading: isLoading,
                  ),

                        // Future LCU API wrappers can be added here:
                        // LoLMatchHistoryAPI, LoLChampionSelectAPI, 
                        // LoLGameflowAPI, LoLLobbyAPI, LoLChatAPI, etc.
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}