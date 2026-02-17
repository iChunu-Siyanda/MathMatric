import 'dart:ui';

class PracticeTopic {
  final String id;
  final String title;
  final String description;
  final int order; // for sorting in UI
  final int totalLevels;
  final int totalXp;
  final Color color; 

  const PracticeTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.totalLevels,
    required this.totalXp,
    required this.color,
  });
}
