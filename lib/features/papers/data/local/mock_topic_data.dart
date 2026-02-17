import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/practice_topic.dart';

final mockTopics = [
  PracticeTopic(
    id: 'algebra',
    title: 'Algebra',
    description: 'Linear and quadratic equations, factorisation, etc.',
    color: Colors.deepPurple, 
    order: 1, 
    totalLevels: 5, 
    totalXp: 20,
  ),
  PracticeTopic(
    id: 'number_sequences',
    title: 'Number Sequences',
    description: 'Arithmetic and geometric sequences.',
    color: Colors.orange, 
    order: 2, 
    totalLevels: 5, 
    totalXp: 13,
  ),
];
