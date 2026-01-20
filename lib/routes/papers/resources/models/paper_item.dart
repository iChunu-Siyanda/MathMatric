import 'package:math_matric/routes/papers/resources/models/exam_paper_model.dart';
import 'package:math_matric/routes/papers/resources/models/topic_item.dart';
//import 'package:math_matric/routes/papers/resources/tabPages/tab_pages.dart';

class PaperItem {
  final String title;
  final String brief;
  final String topicTitle;           
  final List<TopicItem> topics; 
  //final List<TabPages> tabPages;
  final List<ExamPaperModel> ? paper;

  const PaperItem({
    required this.title,
    required this.brief,
    required this.topicTitle,
    required this.topics,
    //required this.tabPages,
    this.paper,
  });
}
