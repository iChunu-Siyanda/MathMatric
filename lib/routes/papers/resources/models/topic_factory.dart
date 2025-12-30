import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/paper_1/data/exam_paper.dart';
import 'package:math_matric/routes/papers/resources/models/tab_model.dart';
import 'package:math_matric/routes/papers/resources/models/topic_item.dart';
import 'package:math_matric/routes/papers/resources/widgets/exam/exam_memo_page.dart';
import 'package:math_matric/routes/papers/resources/widgets/exam/exam_paper_page.dart';

enum TabType {
  progress,
  classNotes,
  practice,
  exam,
}

class TopicFactory {
  static Map<TabType,TabModel> tabSets = {
    TabType.progress : TabModel(
      tabTitles: ["Streak", "Scores"],
      tabPages: [ExamPaperPage(pdfPath: ExamPaperRepository.papers.first.assetPath, pdfTitle: ExamPaperRepository.papers.first.title,), ExamMemoPage(pdfPath: "")],
    ),

    TabType.classNotes: TabModel(
      tabTitles: ["Tips", "Class Notes"],
      tabPages: [ExamPaperPage(pdfPath: ExamPaperRepository.papers.first.assetPath, pdfTitle: ExamPaperRepository.papers.first.title,), ExamMemoPage(pdfPath: "")],
    ),

    TabType.practice: TabModel(
      tabTitles: ["Quiz", "Practice Tests"],
      tabPages: [ExamPaperPage(pdfPath: ExamPaperRepository.papers.first.assetPath, pdfTitle: ExamPaperRepository.papers.first.title,), ExamMemoPage(pdfPath: "")],
    ),

    TabType.exam: TabModel(
      tabTitles: ["Questions", "Memo"],
      tabPages: [ExamPaperPage(pdfPath: ExamPaperRepository.papers.first.assetPath, pdfTitle: ExamPaperRepository.papers.first.title,), ExamMemoPage(pdfPath: "")],
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
