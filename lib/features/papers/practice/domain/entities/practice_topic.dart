//   PracticeTopic
//        ▲
//        │
//    TopicModel
//    ▲        ▲
//    │        │
// Firestore Drift

class PracticeTopic {
  final String id;
  final String subjectId;

  final String title;
  final String description;

  final int order;
  final int totalLevels;
  final int totalXp;

  final String colorHex;

  const PracticeTopic({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.order,
    required this.totalLevels,
    required this.totalXp,
    required this.colorHex,
  });
}
