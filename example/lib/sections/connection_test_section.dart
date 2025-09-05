import 'package:flutter/material.dart';
import '../widgets/api_test_card.dart';
import '../widgets/action_button.dart';

class ConnectionTestSection extends StatelessWidget {
  final VoidCallback onTestConnection;
  final bool isLoading;

  const ConnectionTestSection({
    super.key,
    required this.onTestConnection,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ApiTestCard(
      icon: Icons.link,
      title: 'Connection Test',
      iconColor: Colors.blue.shade400,
      children: [
        ActionButton(
          onPressed: onTestConnection,
          icon: const Icon(Icons.wifi_find),
          label: 'Test Connection',
          backgroundColor: Colors.blue.shade600,
          isLoading: isLoading,
          tooltip: 'Scan for League client process and test connection',
        ),
      ],
    );
  }
}