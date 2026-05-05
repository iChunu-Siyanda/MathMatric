import 'package:math_matric/features/papers/domain/entities/exam_paper.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';

//Enums are much better than strings, they are safe(compile-time safety).
enum ExamSession {
  march,
  june,
  november,
  ieb,
  prelim,
}

class ExamPaperData {
  Map<ExamSession, Map<String, List<ExamPaper>>> getExamItems(PaperType type) {
    switch (type) {
      case PaperType.paper1:
        return _getExamPaper1();
      case PaperType.paper2:
        return _getExamPaper2();
    }
  }

  // March only has provincial papers, June has both national and provincial papers, November has only national papers, IEB November has only national papers, Prelim has only provincial papers. 

  Map<ExamSession, Map<String, List<ExamPaper>>> _getExamPaper(String type) => {
        ExamSession.june: {
          "march_${type}_2024": [
            ExamPaper(//PROVINCIAL
                title: "${type.toUpperCase()} March 2024",
                assetPath: "march/2023_kzn", //assets/papers/paper_1/exams/papers/
                id: 'march_${type}_2023_prov',
                isNational: false,
                pageCount: 8, 
                session: ExamSession.march, 
                year: 2024),    
            ExamPaper(//PROVINCIAL MEMO
              title: "${type.toUpperCase()} March 2024 Memo",
              assetPath:
                  "march/2023_kzn", //assets/papers/paper_1/exams/memos/
              id: 'march_${type}_2023_memo_prov',
              isMemo: true,
              parentPaperId: 'march_${type}_2023_prov', // Same as id of question paper.
              isNational: false,
              pageCount: 8,
              session: ExamSession.march,
              year: 2024,
            ),
          ],
          "june_${type}_2024": [
            ExamPaper( //NATIONAL
                title: "${type.toUpperCase()} June 2024",
                assetPath: "june/2024_nat", //assets/papers/paper_1/exams/papers/
                id: 'june_${type}_2024_nat',
                isNational: true, 
                pageCount: 12, 
                session: ExamSession.june, 
                year: 2024),
            ExamPaper(//PROVINCIAL
                title: "${type.toUpperCase()} June 2024",
                assetPath: "june/2024_prov", //assets/papers/paper_1/exams/papers/
                id: 'june_${type}_2024_prov',
                isNational: false,
                pageCount: 12, 
                session: ExamSession.june, 
                year: 2024),    
            ExamPaper(//NATIONAL MEMO
              title: "${type.toUpperCase()} June 2024 Memo",
              assetPath:
                  "june/2024_nat", //assets/papers/paper_1/exams/memos/
              id: 'june_${type}_2024_memo_nat',
              isMemo: true,
              parentPaperId: 'june_${type}_2024_nat', // Same as id of question paper.
              isNational: true,
              pageCount: 12,
              session: ExamSession.june,
              year: 2024,
            ),
            ExamPaper(//PROVINCIAL MEMO
              title: "${type.toUpperCase()} June 2024 Memo",
              assetPath:
                  "june/2024_prov", //assets/papers/paper_1/exams/memos/
              id: 'june_${type}_2024_memo_prov',
              isMemo: true,
              parentPaperId: 'june_${type}_2024_prov', // Same as id of question paper.
              isNational: false,
              pageCount: 12,
              session: ExamSession.june,
              year: 2024,
            ),
          ]
        },
        ExamSession.prelim: {
          "prelim_${type}_2025": [
            ExamPaper(
                title: "${type.toUpperCase()} Prelim 2025",
                assetPath:
                    "prelim/2025_kzn", //papers/paper_1/exams/papers/
                id: 'prelim_${type}_2025',
                isNational: false,
                pageCount: 13,
                session: ExamSession.prelim,
                year: 2025),
            ExamPaper(
              title: "${type.toUpperCase()} Prelim 2025 Memo",
              assetPath:
                  "prelim/2025_kzn", //papers/paper_1/exams/memos/
              isMemo: true,
              id: 'prelim_${type}_2025_memo',
              parentPaperId: 'prelim_${type}_2025',
              isNational: false,
              pageCount: 13,
              session: ExamSession.prelim,
              year: 2025,
            ),
          ]
        },
        ExamSession.november: {
          "november_${type}_2024": [
            ExamPaper(
                title: "${type.toUpperCase()} November 2024",
                assetPath:
                    "november/2024_nat", //papers/paper_1/exams/papers/
                id: 'november_${type}_2024_nat',
                isNational: true,
                pageCount: 10,
                session: ExamSession.november,
                year: 2024),
            ExamPaper(
                title: "${type.toUpperCase()} November 2024",
                assetPath:
                    "november/2023_nat", //papers/paper_1/exams/papers/
                id: 'november_${type}_2023_nat',
                isNational: true,
                pageCount: 9,
                session: ExamSession.november,
                year: 2023),    
            ExamPaper(
              title: "${type.toUpperCase()} November 2024 Memo",
              assetPath:
                  "november/2024_nat", //papers/paper_1/exams/memos/
              isMemo: true,
              id: 'november_${type}_2024_memo_nat',
              parentPaperId: 'november_${type}_2024',
              isNational: true,
              pageCount: 10,
              session: ExamSession.november,
              year: 2024,
            ),
            ExamPaper(
              title: "${type.toUpperCase()} November 2024 Memo",
              assetPath:
                  "november/2024_nat", //papers/paper_1/exams/memos/
              isMemo: true,
              id: 'november_${type}_2024_memo_nat',
              parentPaperId: 'november_${type}_2024',
              isNational: true,
              pageCount: 9,
              session: ExamSession.november,
              year: 2024,
            ),
          ]
        },
        ExamSession.ieb: {
          "ieb_${type}_2024": [
            ExamPaper(
                title: "${type.toUpperCase()} IEB November 2024",
                assetPath:
                    "ieb/november_ieb/2024", //papers/paper_1/exams/papers/
                id: 'nov_ieb_${type}_2024_nat',
                isNational: true,
                pageCount: 22,
                session: ExamSession.ieb,
                year: 2024),
            ExamPaper(
              title: "${type.toUpperCase()} IEB November 2024",
              assetPath:
                  "ieb/november_ieb/2024", //papers/paper_1/exams/memos/
              isMemo: true,
              id: 'nov_ieb_${type}_2024_memo_nat',
              parentPaperId: 'nov_ieb_${type}_2024',
              isNational: true,
              pageCount: 22,
              session: ExamSession.ieb,
              year: 2024,
            ),
          ]
        }
      };

  Map<ExamSession, Map<String, List<ExamPaper>>> _getExamPaper1() => _getExamPaper("p1");
  Map<ExamSession, Map<String, List<ExamPaper>>> _getExamPaper2() => _getExamPaper("p2");
}
