import 'package:flutter/material.dart';
import 'package:math_matric/app/factories/topic_factory.dart';

class TileTopicsP1Data{
  static const years = [2024, 2023, 2022, 2021, 2020, 2019];

  static List<Color> colors = const [
    Color(0xFF6A6CE5),
    Color(0xFF00BFA6),
    Color(0xFFFF7A59),
    Color(0xFF3A7BD5),
    Color(0xFF9C27B0),
    Color(0xFF00C2FF),
  ];

  static List<IconData> icons = [
    Icons.calculate,
    Icons.straighten,
    Icons.show_chart,
    Icons.functions,
    Icons.timeline,
    Icons.grid_on,
  ];

  static Color colorPicker(int i) => colors[i % colors.length];
  static IconData iconPicker(int i) => icons[i % icons.length];

  //My Progress
  static String myProgressTitle = "My Progress";
  static final myProgress = TopicFactory.categories(
    title: "My Progress",
    names: [
      "Streak",
      "Progress Score",
    ],
    tabType: TabType.progress,
    colorPicker: colorPicker,
    iconPicker: iconPicker,
  );

  //Class Notes
  static String classNotesTitle = "Class Notes";
   static final classNotes = TopicFactory.categories(
    title: "Class Notes",
    names: [
      "Algebra",
      "Number Patterns",
      "Functions",
      "Calculus",
      "Financial Maths",
      "Probabilty",
    ],
    tabType: TabType.classNotes,
    colorPicker: colorPicker,
    iconPicker: iconPicker,
  );

  //Practice Papers
  static String practiceTitle = "Practice Papers";
  static final practicePapers = TopicFactory.categories(
    title: "Practice Papers",
    names: [
      "Algebra",
      "Number Patterns",
      "Functions",
      "Calculus",
      "Financial Maths",
      "Probabilty",
    ],
    tabType: TabType.practice,
    colorPicker: colorPicker,
    iconPicker: iconPicker,
  );

  //March Tests
  static String marchTestsTitle = "March";
  static final marchTests = TopicFactory.yearRange(
    title: "March",
    years: years,
    tabType: TabType.exam,
    colorPicker: colorPicker,
    iconPicker: iconPicker,
  );

  //June Exams
  static String examJuneTitle = "June";
  static final juneExams = TopicFactory.yearRange(
    title: "June",
    years: years,
    tabType: TabType.exam,
    colorPicker: colorPicker,
    iconPicker: iconPicker,
  );

  //Prelims
  static String examPrelimsTitle = "Prelims";
  static final prelimExams = TopicFactory.yearRange(
    title: "Prelims",
    years: years,
    tabType: TabType.exam,
    colorPicker: colorPicker,
    iconPicker: iconPicker,
  );

  //November Exams
  static String examNovemberTitle = "November";
  static final novemberExams = TopicFactory.yearRange(
    title: "November",
    years: years,
    tabType: TabType.exam,
    colorPicker: colorPicker,
    iconPicker: iconPicker,
  );

  //IEB
  static String examIebTitle = "IEB";
  static final iebExams = TopicFactory.yearRange(
    title: "IEB",
    years: years,
    tabType: TabType.exam,
    colorPicker: colorPicker,
    iconPicker: iconPicker,
  );

}