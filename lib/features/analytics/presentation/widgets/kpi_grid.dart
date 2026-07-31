import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';

class KpiGrid extends StatelessWidget {
  final String totalEarnedXP;
  final String overallAccuracy;
  final String overallCompletionRate;
  final String avgTime;

  const KpiGrid({
    super.key,
    required this.totalEarnedXP, 
    required this.overallAccuracy, 
    required this.overallCompletionRate, 
    required this.avgTime,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _KpiTile(
          title: 'Total XP',
          value: 'totalEarnedXP XP',
          icon: Icons.bolt_rounded,
          accentColor: AppColours.warningAmber,
        ),
        _KpiTile(
          title: 'Accuracy',
          value: '$overallAccuracy%',
          icon: Icons.track_changes_rounded,
          accentColor: AppColours.cobaltBlue,
        ),
        _KpiTile(
          title: 'Completion',
          value: '$overallCompletionRate%',
          icon: Icons.military_tech_rounded,
          accentColor: AppColours.correctGreen,
        ),
        _KpiTile(
          title: 'Avg Speed',
          value: '$avgTime / q',
          icon: Icons.timer_outlined,
          accentColor: AppColours.electricViolet,
        ),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _KpiTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColours.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColours.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColours.textMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: accentColor),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColours.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
