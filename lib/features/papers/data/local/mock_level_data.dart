import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';

final mockLevels = [
  PracticeLevel(
    levelId: 'algebra_level1',
    topicId: 'algebra', //must be equal to mockTopics.id
    title: 'Linear Equations',
    subtitle: 'Simple one-variable linear equations',
    //icon: Icons.calculate_rounded,
    color: Colors.deepPurple,
    xpReward: 20,
    isCompleted: false,
    isUnlocked: true,
    progress: 0.0,
  ),
  PracticeLevel(
    levelId: 'algebra_level2',
    topicId: 'algebra',
    title: 'Quadratic Equations',
    subtitle: 'Factorization and formula method',
   // icon: Icons.functions_rounded,
    color: Colors.deepPurple,
    xpReward: 30,
    isCompleted: false,
    isUnlocked: false,
    progress: 0.0,
  ),
  PracticeLevel(
    levelId: 'number_patterns_level1',
    topicId: 'numberPatterns',
    title: 'Arithmetic Sequences',
    subtitle: 'Finding the nth term',
   // icon: Icons.format_list_numbered_rounded,
    color: Colors.orange,
    xpReward: 15,
    isCompleted: false,
    isUnlocked: true,
    progress: 0.0,
  ),
];
