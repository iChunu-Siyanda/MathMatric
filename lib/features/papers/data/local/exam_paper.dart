import 'package:math_matric/features/papers/data/model/exam_paper_model.dart';

//Enums are much better than strings, they are safe(compile-time safety).
enum ExamSession { 
  june,
  november,
  iebNovember,
}

class ExamPaperRepository {
  static final Map<ExamSession, List<ExamPaperModel>> papers = {
    ExamSession.june: [
      ExamPaperModel(
          title: "P1 June 2024",
          assetPath: "papers/paper_1/exams/june/p1_june_2024.pdf")
    ],
    ExamSession.november: [
      ExamPaperModel(
          title: "P1 Novemeber 2024",
          assetPath: "papers/paper_1/exams/november/p1_nov_2024.pdf"),
    ],
    ExamSession.iebNovember: [
      ExamPaperModel(
          title: "P1 IEB November 2024",
          assetPath:
              "papers/paper_1/exams/ieb/november_ieb/p1_ieb_nov_2024.pdf")
    ]
  };
}
