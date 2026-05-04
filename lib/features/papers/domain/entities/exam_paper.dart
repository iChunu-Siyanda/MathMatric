import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';

class ExamPaper {
  final String id;
  final String ? parentPaperId;
  final String title;
  final String assetPath;
  final bool isMemo;
  final bool isNational;
  final int pageCount;
  final ExamSession session; // 👈 ADD
  final int year;

  ExamPaper({
    required this.id,
    this.parentPaperId,
    required this.title,
    required this.assetPath,
    this.isMemo = false,
    this.isNational = true,  
    required this.pageCount, 
    required this.session,
    required this.year,
  });
}
