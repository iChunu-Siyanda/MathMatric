class ExamPaper {
  final String id;
  final String title;
  final String assetPath;
  final bool isMemo;

  ExamPaper({
    required this.id,
    required this.title,
    required this.assetPath,
    this.isMemo = false,
  });
}
