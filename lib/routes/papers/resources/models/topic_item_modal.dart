import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/models/tab_model.dart';

class TopicItem {
  final String title;
  final String subtitle;
  final String pageTitle;
  final Color color;
  final IconData icon; 
  final TabModel tab;

  const TopicItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.tab, 
    required this.pageTitle
  });
}
