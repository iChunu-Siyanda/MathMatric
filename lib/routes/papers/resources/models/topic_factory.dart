import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/models/section_tab.dart';
import 'package:math_matric/routes/papers/resources/models/tab_model.dart';
import 'package:math_matric/routes/papers/resources/models/topic_item.dart';
import 'package:math_matric/routes/papers/resources/widgets/class_notes/class_notes_page.dart';
import 'package:math_matric/routes/papers/resources/widgets/class_notes/class_notes_tips.dart';
import 'package:math_matric/routes/papers/resources/widgets/exam/exam_memo_page.dart';
import 'package:math_matric/routes/papers/resources/widgets/exam/exam_paper_page.dart';
import 'package:math_matric/routes/papers/resources/widgets/my_progress/streak/screen/streak_screen.dart';
import 'package:math_matric/routes/papers/resources/widgets/practice_papers/practice_page.dart';
import 'package:math_matric/routes/papers/resources/widgets/practice_papers/quizzes_page.dart';

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
          builder: (ctx) => StreakScreen()), //Lazy-loaded widgets in the builder
      SectionTab(title: "Scores", builder: (ctx) => StreakScreen())
    ]),

    //Class Notes
    TabType.classNotes: TabModel(
      tabs: [
        SectionTab(
          title: "Tips",
          builder: (ctx) => ClassNotesTips(),
        ),
        SectionTab(title: "Class Notes", builder: (ctx) => ClassNotesPage())
      ],
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
      ],
    ),

    //Exams
    TabType.exam: TabModel(
      tabs: [
        SectionTab(
          title: "Questions",
          builder: (ctx) => ExamPaperPage(
            contextData: ctx,
          ),
        ),
        SectionTab(
          title: "Memo",
          builder: (ctx) => ExamMemoPage(contextData: ctx),
        ),
      ],
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
