import 'package:flutter/material.dart';

class BuildEmptyState extends StatelessWidget {
  const BuildEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Study History Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            'Topics you access will appear here automatically.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
 
