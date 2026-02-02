class ExamPaper {
  final String id;
  final String ? parentPaperId;
  final String title;
  final String assetPath;
  final bool isMemo;

  ExamPaper({
    required this.id,
    this.parentPaperId,
    required this.title,
    required this.assetPath,
    this.isMemo = false,
  });
}
