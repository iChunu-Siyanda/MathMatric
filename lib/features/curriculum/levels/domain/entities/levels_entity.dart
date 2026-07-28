class LevelsEntity {
  final String id;
  final String topicId;
  final String title;
  final String subtitle;
  final int order;
  final int xpReward;

  const LevelsEntity({
    required this.id, 
    required this.topicId, 
    required this.title, 
    required this.subtitle, 
    required this.order, 
    required this.xpReward,
  });
}
