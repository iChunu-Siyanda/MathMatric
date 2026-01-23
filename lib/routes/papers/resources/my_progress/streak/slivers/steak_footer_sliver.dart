import 'package:flutter/material.dart';

class StreakFooterSliver extends StatelessWidget {
  const StreakFooterSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'One more day to match your longest streak',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
