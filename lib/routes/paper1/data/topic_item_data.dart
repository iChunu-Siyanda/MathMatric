//Create Models - To Do
//sample topicsl
import 'package:flutter/material.dart';
import 'package:math_matric/routes/paper1/data/topic_item.dart';

class TileTopics {
  static String practiceTitle = "Practice Papers";
  static List<TopicItem> problems = const [
    TopicItem(title: 'Algebra', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF6A6CE5), icon: Icons.calculate),
    TopicItem(title: 'Geometry', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF00BFA6), icon: Icons.straighten),
    TopicItem(title: 'Trigonometry', subtitle: 'Grade 12 · Paper 1', color: Color(0xFFFF7A59), icon: Icons.show_chart),
    TopicItem(title: 'Calculus', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF3A7BD5), icon: Icons.functions),
    TopicItem(title: 'Functions', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF9C27B0), icon: Icons.timeline),
    TopicItem(title: 'Graphs', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF00C2FF), icon: Icons.grid_on),
  ];

  static String examTitle = "Exams";
  static List<TopicItem> exams = const [
    TopicItem(title: '2024', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF6A6CE5), icon: Icons.calculate),
    TopicItem(title: '2023', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF00BFA6), icon: Icons.straighten),
    TopicItem(title: '2022', subtitle: 'Grade 12 · Paper 1', color: Color(0xFFFF7A59), icon: Icons.show_chart),
    TopicItem(title: '2021', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF3A7BD5), icon: Icons.functions),
    TopicItem(title: '2020', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF9C27B0), icon: Icons.timeline),
    TopicItem(title: '2019', subtitle: 'Grade 12 · Paper 1', color: Color(0xFF00C2FF), icon: Icons.grid_on),
  ];
}
