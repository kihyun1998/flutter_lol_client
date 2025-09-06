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
      title: 'LCU Connection',
      iconColor: Colors.blue.shade400,
      children: [
        ActionButton(
          onPressed: onTestConnection,
          icon: const Icon(Icons.wifi_find),
          label: 'Scan & Connect to LCU',
          backgroundColor: Colors.blue.shade600,
          isLoading: isLoading,
          tooltip: 'Scans for League Client Update (LCU) process and establishes connection\n\nFinds lockfile, extracts port/token, tests HTTPS connection',
        ),
        const SizedBox(height: 8),
        Text(
          'Automatically detects League client and connects to LCU API (https://127.0.0.1:port)',
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