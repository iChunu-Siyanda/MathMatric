import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/app/navigation/section_tab_entities.dart';
import 'package:math_matric/app/navigation/tab_entities.dart';
import 'package:math_matric/features/papers/domain/entities/topic_item.dart';
import 'package:math_matric/features/papers/presentation/pages/class_notes/class_notes_page.dart';
import 'package:math_matric/features/papers/presentation/pages/class_notes/class_notes_tips.dart';
import 'package:math_matric/features/papers/presentation/pages/exam/exam_paper_page.dart';
import 'package:math_matric/features/streak/presentation/pages/streak_screen.dart';
import 'package:math_matric/features/papers/presentation/pages/practice/practice_page.dart';
import 'package:math_matric/features/papers/presentation/pages/practice/quizzes_page.dart';

enum TabType {
  progress,
  classNotes,
  practice,
  exam,
}

class TopicFactory {
  static Map<TabType, TabModel> tabSets = {
    //My Progress
    TabType.progress: TabModel(tabs: [
      SectionTab(
          title: "Streak",
          builder: (ctx) =>
              StreakScreen()), //Lazy-loaded widgets in the builder
      SectionTab(title: "Scores", builder: (ctx) => StreakScreen())
    ], tabType: TabType.progress),

    //Class Notes
    TabType.classNotes: TabModel(
      tabs: [
        SectionTab(
          title: "Tips",
          builder: (ctx) => ClassNotesTips(),
        ),
        SectionTab(title: "Class Notes", builder: (ctx) => ClassNotesPage())
      ], tabType: TabType.classNotes,
    ),

    //Practice
    TabType.practice: TabModel(
      tabs: [
        SectionTab(
          title: "Quiz",
          builder: (ctx) => QuizzesPage(),
        ),
        SectionTab(
          title: "Practice Tests",
          builder: (ctx) => PracticePage(),
        ),
      ], tabType: TabType.practice,
    ),

    //Exams
    TabType.exam: TabModel(
      tabs: [
        SectionTab(
          title: "Questions",
          builder: (ctx) => ExamPaperPage(
            contextData: ctx,
            mode: ExamPageMode.paper,
            paperType: ctx.paperType,
          ),
        ),
        SectionTab(
          title: "Memo",
          builder: (ctx) => ExamPaperPage(
            contextData: ctx,
            mode: ExamPageMode.memo,
            paperType: ctx.paperType,
          ),
        ),
      ], tabType: TabType.exam,
    ),
  };

  static List<TopicItem> yearRange({
    required String title,
    required List<int> years,
    required TabType tabType,
    required Color Function(int index) colorPicker,
    required IconData Function(int index) iconPicker,
  }) {
    return List.generate(years.length, (i) {
      final y = years[i];
      return TopicItem(
        title: "$y",
        subtitle: "Grade 12 · Paper 1",
        color: colorPicker(i),
        icon: iconPicker(i),
        pageTitle: title,
        tab: tabSets[tabType]!,
      );
    });
  }

  static List<TopicItem> categories({
    required String title,
    required List<String> names,
    required TabType tabType,
    required Color Function(int index) colorPicker,
    required IconData Function(int index) iconPicker,
  }) {
    return List.generate(names.length, (i) {
      return TopicItem(
        title: names[i],
        subtitle: "Grade 12 · Paper 1",
        color: colorPicker(i),
        icon: iconPicker(i),
        pageTitle: title,
        tab: tabSets[tabType]!,
      );
    });
  }
}
