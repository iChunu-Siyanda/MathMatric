import 'package:flutter/material.dart';
import 'package:math_matric/features/ui/analytics/presentation/pages/analytics_page.dart';
import 'package:math_matric/features/ui/exam/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/shared/entities/section_tab_entities.dart';
import 'package:math_matric/shared/entities/tab_entities.dart';
import 'package:math_matric/features/ui/papers/domain/entities/topic_item.dart';
import 'package:math_matric/features/ui/classnotes/presentation/pages/class_notes_page.dart';
import 'package:math_matric/features/ui/classnotes/presentation/pages/class_notes_tips.dart';
import 'package:math_matric/features/ui/exam/presentation/pages/exam_paper_page.dart';
import 'package:math_matric/features/ui/practice/presentation/pages/practice_page.dart';
import 'package:math_matric/features/ui/quiz/presentation/pages/quizzes_page.dart';
import 'package:math_matric/shared/entities/tab_type.dart';

class TopicFactory {
  static final Map<TabType, TabModel> tabSets = {
    // -------------------------------------------------------------------------
    // MY PROGRESS
    // -------------------------------------------------------------------------
    TabType.progress: TabModel(
      tabs: [
        SectionTab(
          title: "Streak",
          builder: (_) => AnalyticsPage(),
        ),
        SectionTab(
          title: "Scores",
          builder: (_) => AnalyticsPage(),
        ),
      ],
      tabType: TabType.progress,
    ),

    // -------------------------------------------------------------------------
    // CLASS NOTES
    // -------------------------------------------------------------------------
    TabType.classNotes: TabModel(
      tabs: [
        SectionTab(
          title: "Tips",
          builder: (_) => ClassNotesTips(),
        ),
        SectionTab(
          title: "Class Notes",
          builder: (ctx) => ClassNotesPage(
            topicId: ctx.topic.topicId ?? 'general',
          ),
        ),
      ],
      tabType: TabType.classNotes,
    ),

    // -------------------------------------------------------------------------
    // PRACTICE PAPERS
    // -------------------------------------------------------------------------
    TabType.practicePapers: TabModel(
      tabs: [
        SectionTab(
          title: "Quiz",
          builder: (ctx) => QuizzesPage(
            topicId: ctx.topic.topicId ?? 'general',
          ),
        ),
        SectionTab(
          title: "Practice Tests",
          builder: (ctx) => PracticePage(
            topicId: ctx.topic.topicId ?? 'general',
          ),
        ),
      ],
      tabType: TabType.practicePapers,
    ),

    // -------------------------------------------------------------------------
    // EXAM PAPERS & MEMOS (Supports National & Provincial per Year)
    // -------------------------------------------------------------------------
    TabType.exam: TabModel(
      tabs: [
        SectionTab(
          title: "Questions",
          examMode: ExamPageMode.paper,
          builder: (ctx) {
            final paperId = ctx.topic.paperId ?? ctx.topic.topicId;
            if (paperId == null) {
              debugPrint("DEBUG: Missing paperId and topicId for context: $ctx");
              return const Center(child: Text("Error: Subject ID missing"));
            }
            return ExamPaperPage(
              contextData: ctx,
              mode: ExamPageMode.paper,
              paperId: paperId,
            );
          },
        ),
        SectionTab(
          title: "Memo",
          examMode: ExamPageMode.memo,
          builder: (ctx) {
            final paperId = ctx.topic.paperId ?? ctx.topic.topicId;
            if (paperId == null) {
              return const Center(child: Text("Error: Subject ID missing"));
            }
            return ExamPaperPage(
              contextData: ctx,
              mode: ExamPageMode.memo,
              paperId: paperId,
            );
          },
        ),
      ],
      tabType: TabType.exam,
    ),
  };

  // ---------------------------------------------------------------------------
  // YEAR RANGE GENERATOR (Exams: March, June, Prelims, November, IEB)
  // ---------------------------------------------------------------------------
  static List<TopicItem> yearRange({
    required String title,
    required List<int> years,
    required TabType tabType,
    required Color Function(int index) colorPicker,
    required IconData Function(int index) iconPicker,
    required String month,
    String subjectId = 'mathematics_grade12',
  }) {
    return List.generate(years.length, (i) {
      final y = years[i];

      return TopicItem(
        // Passes subjectId down so ExamPaperPage queries all National & Provincial papers for this year
        topicId: subjectId,
        paperId: subjectId,
        title: "$y",
        subtitle: "Grade 12 · Paper 1",
        color: colorPicker(i),
        icon: iconPicker(i),
        pageTitle: title,
        tab: tabSets[tabType]!,
      );
    });
  }

  // ---------------------------------------------------------------------------
  // CATEGORIES GENERATOR (Class Notes, Practice, Progress)
  // ---------------------------------------------------------------------------
  static List<TopicItem> categories({
    required String title,
    required List<String> names,
    required TabType tabType,
    required Color Function(int index) colorPicker,
    required IconData Function(int index) iconPicker,
    String subjectId = 'mathematics_grade12',
  }) {
    return List.generate(names.length, (i) {
      final topicName = names[i];
      final topicSlug = topicName.toLowerCase().replaceAll(' ', '_');

      return TopicItem(
        topicId: topicSlug, // e.g. "algebra", "functions"
        paperId: subjectId,
        title: topicName,
        subtitle: "Grade 12 · Paper 1",
        color: colorPicker(i),
        icon: iconPicker(i),
        pageTitle: title,
        tab: tabSets[tabType]!,
      );
    });
  }
}
