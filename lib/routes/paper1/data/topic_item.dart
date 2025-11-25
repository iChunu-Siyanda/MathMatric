import 'package:flutter/material.dart';

class TopicItem {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const TopicItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}
