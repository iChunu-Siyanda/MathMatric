import 'package:math_matric/routes/papers/paper_1/data/tile_topics_data.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';


class PaperItemData {
  static List<PaperItem> items = [
    PaperItem(
      title: "My Progress",
      brief: "Passing with flying colours",
      topicTitle: TileTopics.myProgressTitle,
      topics: TileTopics.myProgress,
    ),
    PaperItem(
      title: 'Class Notes', 
      brief: 'Notes on every section',
      topicTitle: TileTopics.classNotesTitle,
      topics: TileTopics.classNotes,
    ),
    PaperItem(
      title: 'Practice Papers',
      brief: 'Practice makes perferct',
      topicTitle: TileTopics.practiceTitle,
      topics: TileTopics.practicePapers,
    ),
    PaperItem(
      title: 'March',
      brief: 'March Tests',
      topicTitle: TileTopics.marchTestsTitle,
      topics: TileTopics.marchTests,
    ),
    PaperItem(
      title: 'June',
      brief: 'June Examinations',
      topicTitle: TileTopics.examJuneTitle,
      topics: TileTopics.juneExams,
    ),
    PaperItem(
      title: 'Prelims',
      brief: 'Preliminary Examinations',
      topicTitle: TileTopics.examPrelimsTitle,
      topics: TileTopics.prelimExams,
    ),
    PaperItem(
      title: 'November',
      brief: 'November Examinations',
      topicTitle: TileTopics.examNovemberTitle,
      topics: TileTopics.novemberExams,
    ),
    PaperItem(
      title: "IEB",
      brief: "IEB Examinations",
      topicTitle: TileTopics.examIebTitle,
      topics: TileTopics.iebExams,
    ),
  ];
}
