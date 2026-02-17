import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';

final mockLevels = [
  PracticeLevel(
    id: 'algebra_level1',
    topicId: 'algebra',
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
    id: 'algebra_level2',
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
    id: 'number_sequences_level1',
    topicId: 'number_sequences',
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
