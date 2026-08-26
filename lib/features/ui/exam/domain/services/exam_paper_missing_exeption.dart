/// Exception thrown when a specific page of an exam paper cannot be found or loaded.
class ExamPaperMissingPageException implements Exception {
  final String paperId;
  final String fileName;
  final String message;

  ExamPaperMissingPageException({
    required this.paperId,
    required this.fileName,
  }) : message = 'Exam paper (ID: $paperId) page not found: $fileName';

  @override
  String toString() => 'ExamPaperMissingPageException: $message';
}
