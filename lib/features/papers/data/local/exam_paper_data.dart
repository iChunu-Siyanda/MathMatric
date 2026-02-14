import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';

//Enums are much better than strings, they are safe(compile-time safety).
enum ExamSession {
  june,
  november,
  iebNovember,
}

class ExamPaperData {
  Map<ExamSession, List<ExamPaper>> getExamItems(PaperType type) {
    switch (type) {
      case PaperType.paper1:
        return _getExamPaper1();
      case PaperType.paper2:
        return _getExamPaper2();
    }
  }

  Map<ExamSession, List<ExamPaper>> _getExamPaper1() => {
        ExamSession.june: [
          ExamPaper(
              title: "P1 June 2024",
              assetPath: "papers/paper_1/exams/papers/june/p1_june_2024.pdf",
              id: 'june_p1_2024'),
          ExamPaper(
            title: "P1 June 2024 Memo",
            assetPath: "papers/paper_1/exams/memos/june/p1_june_2024_memo.pdf",
            id: 'june_p1_2024_memo',
            isMemo: true,
            parentPaperId: 'june_p1_2024', // Same as id of question paper.
          )
        ],
        ExamSession.november: [
          ExamPaper(
              title: "P1 Novemeber 2024",
              assetPath: "papers/paper_1/exams/papers/november/p1_nov_2024.pdf",
              id: 'november_p1_2024'),
          ExamPaper(
            title: "P1 Novemeber 2024",
            assetPath:
                "papers/paper_1/exams/memos/november/p1_nov_2024_memo.pdf",
            isMemo: true,
            id: 'november_p1_2024_memo',
            parentPaperId: 'november_p1_2024',
          ),
        ],
        ExamSession.iebNovember: [
          ExamPaper(
              title: "P1 IEB November 2024",
              assetPath:
                  "papers/paper_1/exams/papers/ieb/november_ieb/p1_ieb_nov_2024.pdf",
              id: 'nov_ieb_p1_2024'),
          ExamPaper(
            title: "P1 IEB November 2024",
            assetPath:
                "papers/paper_1/exams/memos/ieb/november_ieb/p1_ieb_nov_2024_memo.pdf",
            isMemo: true,
            id: 'nov_ieb_p1_2024',
            parentPaperId: 'nov_ieb_p1_2024',
          )
        ]
      };

  Map<ExamSession, List<ExamPaper>> _getExamPaper2() => {};
}
