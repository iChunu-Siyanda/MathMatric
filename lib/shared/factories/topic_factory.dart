import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/shared/entities/section_tab_entities.dart';
import 'package:math_matric/shared/entities/tab_entities.dart';
import 'package:math_matric/features/papers/papers/domain/entities/topic_item.dart';
import 'package:math_matric/features/papers/classnotes/presentation/pages/class_notes_page.dart';
import 'package:math_matric/features/papers/classnotes/presentation/pages/class_notes_tips.dart';
import 'package:math_matric/features/papers/exam/presentation/pages/exam_paper_page.dart';
import 'package:math_matric/features/streak/presentation/pages/streak_screen.dart';
import 'package:math_matric/features/papers/practice/presentation/pages/practice_page.dart';
import 'package:math_matric/features/papers/practice/presentation/pages/quizzes_page.dart';
import 'package:math_matric/shared/entities/tab_type.dart';

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
      ],
      tabType: TabType.classNotes,
    ),

    //Practice
    TabType.practicePapers: TabModel(
      tabs: [
        SectionTab(
          title: "Quiz",
          builder: (ctx) => QuizzesPage(topicId: ctx.topic.topicId!,),
        ),
        SectionTab(
          title: "Practice Tests",
          builder: (ctx) => PracticePage(),
        ),
      ],
      tabType: TabType.practicePapers,
    ),

    //Exams
    TabType.exam: TabModel(
      tabs: [
        SectionTab(
            title: "Questions",
            examMode: ExamPageMode.paper,
            builder: (ctx) {
              if (ctx.topic.paperId == null) {
                debugPrint("DEBUG: paperId is null for topic: ${ctx.topic}");
                return const Center(child: Text("Error: Paper ID missing"));
              }
              return ExamPaperPage(
                contextData: ctx,
                mode: ExamPageMode.paper,
                paperId: ctx.topic.paperId!, 
              );
            }),
        SectionTab(
          title: "Memo",
          examMode: ExamPageMode.memo,
          builder: (ctx) => ExamPaperPage(
            contextData: ctx,
            mode: ExamPageMode.memo,
            paperId: ctx.topic.paperId!, 
          ),
        ),
      ],
      tabType: TabType.exam,
    ),
  };

  static List<TopicItem> yearRange({
    required String title,
    required List<int> years,
    required TabType tabType,
    required Color Function(int index) colorPicker,
    required IconData Function(int index) iconPicker,
    required String month,
  }) {
    return List.generate(years.length, (i) {
      final y = years[i];
      return TopicItem(
        title: "$y",
        subtitle: "Grade 12 · Paper 1",
        paperId: "${month.toLowerCase()}_p1_$y",
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
        topicId: names[i],
        subtitle: "Grade 12 · Paper 1",
        color: colorPicker(i),
        icon: iconPicker(i),
        pageTitle: title,
        tab: tabSets[tabType]!, 
      );
    });
  }
}
