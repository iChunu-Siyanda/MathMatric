class ExamPaperModel {
  final String title;       // "Math Paper 1 (2023)"
  final String assetPath;   // "assets/papers/2023_p1.pdf"
  final bool isMemo;        // true if it's a memo
  final bool liked;         // optional for favorites

  ExamPaperModel({
    required this.title,
    required this.assetPath,
    this.isMemo = false,
    this.liked = false,
  });
}
