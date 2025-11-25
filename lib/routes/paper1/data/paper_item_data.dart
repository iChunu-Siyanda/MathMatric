import 'package:math_matric/routes/paper1/data/paper_item.dart';
import 'package:math_matric/routes/paper1/data/topic_item_data.dart';

class PaperItemData {
  static List<PaperItem> items = [
    PaperItem(
      title: "My Progress",
      brief: "Passing with flying colours",
      topicTitle: TileTopics.practiceTitle,
      topics: TileTopics.problems,
    ),
    PaperItem(
      title: 'Class Notes',
      brief: 'Notes on every section',
      topicTitle: TileTopics.practiceTitle,
      topics: TileTopics.problems,
    ),
    PaperItem(
      title: 'Practice Papers',
      brief: 'Practice makes perferct',
      topicTitle: TileTopics.practiceTitle,
      topics: TileTopics.problems,
    ),
    PaperItem(
      title: 'March',
      brief: 'March Tests',
      topicTitle: TileTopics.examTitle,
      topics: TileTopics.exams,
    ),
    PaperItem(
      title: 'June',
      brief: 'June Examinations',
      topicTitle: TileTopics.examTitle,
      topics: TileTopics.exams,
    ),
    PaperItem(
      title: 'Prelims',
      brief: 'Preliminary Examinations',
      topicTitle: TileTopics.examTitle,
      topics: TileTopics.exams,
    ),
    PaperItem(
      title: 'November',
      brief: 'November Examinations',
      topicTitle: TileTopics.examTitle,
      topics: TileTopics.exams,
    ),
    PaperItem(
      title: "IEB",
      brief: "IEB examinations",
      topicTitle: TileTopics.examTitle,
      topics: TileTopics.exams,
    ),
  ];
}
