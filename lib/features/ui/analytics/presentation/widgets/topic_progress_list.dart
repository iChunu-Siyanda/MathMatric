import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/topic_progress_card_entity.dart';

class TopicProgressList extends StatelessWidget {
  final List<TopicProgressCardEntity> topicCards;

  const TopicProgressList({super.key, required this.topicCards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: topicCards.map((card) {
        final accent = card.accentColor;
        final scorePercentage = (card.averageBestScore * 100).toInt();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColours.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColours.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Topic Title & Score/Accuracy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      card.topic.id,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColours.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$scorePercentage% Avg Score',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Progress Bar (Level Completion)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (card.completionPercentage / 100).clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: AppColours.surfaceSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
              const SizedBox(height: 10),

              // Meta Subtext Row: Levels Completed & Last Played
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${card.completedLevels}/${card.totalLevels} Levels Completed',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColours.textMuted,
                    ),
                  ),
                  Text(
                    card.lastPlayed != null
                        ? 'Played ${_formatDate(card.lastPlayed!)}'
                        : 'Not started',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColours.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}
