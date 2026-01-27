import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';

//Enums are much better than strings, they are safe(compile-time safety).
enum ExamSession {
  june,
  november,
  iebNovember,
}

class ExamPaperRepository {
  static final Map<ExamSession, List<ExamPaper>> papers = {
    ExamSession.june: [
      ExamPaper(
          title: "P1 June 2024",
          assetPath: "papers/paper_1/exams/june/p1_june_2024.pdf",
          id: 'june_p1_2024')
    ],
    ExamSession.november: [
      ExamPaper(
          title: "P1 Novemeber 2024",
          assetPath: "papers/paper_1/exams/november/p1_nov_2024.pdf",
          id: 'november_p1_2024'),
    ],
    ExamSession.iebNovember: [
      ExamPaper(
          title: "P1 IEB November 2024",
          assetPath:
              "papers/paper_1/exams/ieb/november_ieb/p1_ieb_nov_2024.pdf",
          id: 'nov_ieb_p1_2024')
    ]
  };

}
