import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/models/section_context_modal.dart';

class SectionTab {
  final String title;
  final Widget Function(SectionContext ctx) builder;

  const SectionTab({
    required this.title,
    required this.builder,
  });
}
