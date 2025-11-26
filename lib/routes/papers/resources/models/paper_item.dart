import 'package:math_matric/routes/papers/resources/models/topic_item.dart';

class PaperItem {
  final String title;
  final String brief;

  final String topicTitle;           
  final List<TopicItem> topics;   

  const PaperItem({
    required this.title,
    required this.brief,
    required this.topicTitle,
    required this.topics,
  });
}
