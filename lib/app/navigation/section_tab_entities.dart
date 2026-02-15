import 'package:flutter/material.dart';
import 'package:math_matric/app/navigation/section_context_modal.dart';
import 'package:math_matric/features/papers/domain/entities/exam_page_mode.dart.dart';

class SectionTab {
  final String title;
  final Widget Function(SectionContext ctx) builder;
  final ExamPageMode ? examMode;

  const SectionTab({
    required this.title,
    required this.builder,
    this.examMode,
  });
}
