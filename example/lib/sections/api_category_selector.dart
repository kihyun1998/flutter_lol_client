import 'package:flutter/material.dart';
import '../models/api_category.dart';
import '../widgets/api_test_card.dart';
import '../widgets/action_button.dart';

class ApiCategorySelector extends StatelessWidget {
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

  const ApiCategorySelector({
    super.key,
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
    final selectedCategoryData = ApiCategory.getByType(selectedCategory);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Category Dropdown
        ApiTestCard(
          icon: Icons.api,
          title: 'Select LCU Endpoint',
          iconColor: Theme.of(context).colorScheme.primary,
          children: [
            DropdownButtonFormField<ApiCategoryType>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Choose API Endpoint',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                labelStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  selectedCategoryData.icon,
                  color: selectedCategoryData.color,
                ),
              ),
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              isExpanded: true,
              items: ApiCategory.categories.map((category) {
                return DropdownMenuItem<ApiCategoryType>(
                  value: category.type,
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 8),
            Text(
              selectedCategoryData.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Selected Category Content
        _buildCategoryContent(),
      ],
    );
  }

  Widget _buildCategoryContent() {
    final selectedCategoryData = ApiCategory.getByType(selectedCategory);
    
    return ApiTestCard(
      icon: selectedCategoryData.icon,
      title: 'Test Endpoint',
      iconColor: selectedCategoryData.color,
      children: [
        if (selectedCategory == ApiCategoryType.getSummonerById) ...[
          TextField(
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
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
        ],
        if (selectedCategory == ApiCategoryType.getSummonerByPuuid) ...[
          TextField(
            controller: puuidController,
            decoration: InputDecoration(
              labelText: 'PUUID',
              hintText: 'Enter PUUID',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              labelStyle: TextStyle(color: Colors.grey.shade400),
              hintStyle: TextStyle(color: Colors.grey.shade600),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
        ],
        if (selectedCategory == ApiCategoryType.checkNameAvailability) ...[
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Summoner Name',
              hintText: 'Enter summoner name to check',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              labelStyle: TextStyle(color: Colors.grey.shade400),
              hintStyle: TextStyle(color: Colors.grey.shade600),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
        ],
        ActionButton(
          onPressed: _getEndpointCallback(),
          icon: Icon(selectedCategoryData.icon),
          label: 'Execute Request',
          backgroundColor: selectedCategoryData.color,
          isLoading: isLoading,
          tooltip: selectedCategoryData.name,
        ),
      ],
    );
  }

  VoidCallback _getEndpointCallback() {
    switch (selectedCategory) {
      case ApiCategoryType.getCurrentSummoner:
        return onGetCurrentSummoner;
      case ApiCategoryType.getSummonerById:
        return onGetSummonerById;
      case ApiCategoryType.getSummonerByPuuid:
        return onGetSummonerByPuuid;
      case ApiCategoryType.getCurrentSummonerIds:
        return onGetCurrentSummonerIds;
      case ApiCategoryType.getCurrentSummonerRerollPoints:
        return onGetCurrentSummonerRerollPoints;
      case ApiCategoryType.getCurrentSummonerProfile:
        return onGetCurrentSummonerProfile;
      case ApiCategoryType.getCurrentSummonerJwt:
        return onGetCurrentSummonerJwt;
      case ApiCategoryType.getCurrentSummonerPrivacy:
        return onGetCurrentSummonerPrivacy;
      case ApiCategoryType.checkNameAvailability:
        return onCheckNameAvailability;
      case ApiCategoryType.getSummonerServiceStatus:
        return onGetSummonerServiceStatus;
      case ApiCategoryType.getCurrentSummonerAutofill:
        return onGetCurrentSummonerAutofill;
    }
  }
}