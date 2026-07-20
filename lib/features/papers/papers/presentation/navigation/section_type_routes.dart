import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_bloc.dart';
import 'package:math_matric/features/papers/papers/domain/entities/section_type_arguments.dart';
import 'package:math_matric/features/papers/papers/presentation/pages/section_type.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/entities/tab_type.dart';
import 'package:math_matric/shared/registrations/register_exams_module.dart';

class SectionPageRoutes {
  const SectionPageRoutes._();

  static String _toCamelCase(String? input) {
    if (input == null || input.isEmpty) return '';

    final splitBoundaries = input.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (m) => '${m[1]} ${m[2]}',
    );
    
    final cleanString = splitBoundaries.replaceAll(RegExp(r'[\s\-_]+'), ' ');
    final words = cleanString.trim().split(' ');
    if (words.isEmpty) return '';

    final buffer = StringBuffer(words[0].toLowerCase());
    for (var i = 1; i < words.length; i++) {
      final word = words[i];
      if (word.isNotEmpty) {
        buffer.write(word[0].toUpperCase() + word.substring(1).toLowerCase());
      }
    }

    return buffer.toString();
  }

  
  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.sectionPage,
      builder: (context, state) {
        final args = state.extra as SectionTypeArguments;

        final Widget page = switch (args.tabType) {
          TabType.exam => () {
              debugPrint(
                "args.tabType = ${args.tabType}, sectionContext = ${args.sectionContext}, tabs: ${args.tabs}, pageTitle: ${args.pageTitle}",
              );
              return BlocProvider(
                create: (_) => getIt<ExamBloc>(),
                child: SectionType(
                  pageTitle: args.pageTitle,
                  sectionContext: args.sectionContext,
                  tabs: args.tabs,
                ),
              );
            }(),

          TabType.practicePapers => () {
              final topicID = _toCamelCase(args.topicId);
              debugPrint(
                "args.tabType = ${args.tabType}, TopicId = $topicID, tabs: ${args.tabs}, pageTitle: ${args.pageTitle}",
              );
              return SectionType(
                pageTitle: args.pageTitle,
                sectionContext: args.sectionContext,
                tabs: args.tabs,
              );
            }(),

          TabType.classNotes => () {
              final topicID = _toCamelCase(args.topicId);
              debugPrint(
                "args.tabType = ${args.tabType}, TopicId = $topicID, tabs: ${args.tabs}, pageTitle: ${args.pageTitle}",
              );
              return SectionType(
                pageTitle: args.pageTitle,
                sectionContext: args.sectionContext,
                tabs: args.tabs,
              );
            }(),

          _ => SectionType(
              pageTitle: args.pageTitle,
              sectionContext: args.sectionContext,
              tabs: args.tabs,
            ),
        };

        return page;
      },
    ),
  ];
}
