import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/section_header.dart';

class RightPanel extends StatelessWidget {
  final String result;
  final ScrollController scrollController;
  final VoidCallback onClearResult;
  final VoidCallback onCopyResult;

  const RightPanel({
    super.key,
    required this.result,
    required this.scrollController,
    required this.onClearResult,
    required this.onCopyResult,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Results Header
          SectionHeader(
            icon: Icons.terminal,
            title: result.isEmpty 
                ? 'Results' 
                : 'Results (${result.split('\n').length} lines)',
            iconColor: Colors.orange.shade400,
          ),
          
          // Action Bar
          if (result.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade700),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: onClearResult,
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear result',
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onCopyResult,
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy result',
                    color: Colors.blue.shade400,
                  ),
                ],
              ),
            ),
          
          // Results Content
          Expanded(
            child: result.isEmpty
                ? _buildEmptyState()
                : _buildResultContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code,
            size: 64,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            'No results yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Run an API test to see results here',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade700,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox.expand(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Align(
            alignment: Alignment.topLeft,
            child: SelectableText(
              result,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 14,
                color: Colors.green.shade300,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}