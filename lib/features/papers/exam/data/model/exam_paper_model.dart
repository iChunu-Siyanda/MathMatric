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

//Use for Firebase/JSON/Local storage
// class ExamPaperModel extends ExamPaper {
//   final bool liked; // UI / local state only

//   ExamPaperModel({
//     required String id,
//     required String title,
//     required String assetPath,
//     bool isMemo = false,
//     this.liked = false,
//   }) : super(
//           id: id,
//           title: title,
//           assetPath: assetPath,
//           isMemo: isMemo,
//         );

//   factory ExamPaperModel.fromJson(Map<String, dynamic> json) => ExamPaperModel(
//         id: json['id'],
//         title: json['title'],
//         assetPath: json['assetPath'],
//         isMemo: json['isMemo'] ?? false,
//         liked: json['liked'] ?? false,
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'title': title,
//         'assetPath': assetPath,
//         'isMemo': isMemo,
//         'liked': liked,
//       };
// }
