import 'package:math_matric/features/papers/data/local/tile_topics_p1_data.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';


class PaperTileLocalData {
  List<PaperItem> getPaperItems(PaperType type) {
    switch (type) {
      case PaperType.paper1:
        return _paper1TileItems();
      case PaperType.paper2:
        return _paper2TileItems();
    }
  }

  List<PaperItem> _paper1TileItems() => [
        PaperItem(
          title: "My Progress",
          brief: "Passing with flying colours",
          section: Section(title: TileTopicsP1Data.myProgressTitle, topics: TileTopicsP1Data.myProgress,),
        ),
        PaperItem(
          title: 'Class Notes',
          brief: 'Notes on every section',
          section: Section(title: TileTopicsP1Data.classNotesTitle, topics: TileTopicsP1Data.classNotes,),
        ),
        PaperItem(
          title: 'Practice Papers',
          brief: 'Practice makes perfect',
          section: Section(title: TileTopicsP1Data.practiceTitle,topics: TileTopicsP1Data.practicePapers,),
        ),
        PaperItem(
          title: 'March',
          brief: 'March Tests',
          section: Section(title: TileTopicsP1Data.marchTestsTitle, topics: TileTopicsP1Data.marchTests,), 
        ),
        PaperItem(
          title: 'June',
          brief: 'June Examinations',
          section: Section(title:  TileTopicsP1Data.examJuneTitle, topics: TileTopicsP1Data.juneExams,),
        ),
        PaperItem(
          title: 'Prelims',
          brief: 'Preliminary Examinations',
          section: Section(title: TileTopicsP1Data.examPrelimsTitle, topics: TileTopicsP1Data.prelimExams,), 
        ),
        PaperItem(
          title: 'November',
          brief: 'November Examinations',
          section: Section(title: TileTopicsP1Data.examNovemberTitle, topics: TileTopicsP1Data.novemberExams,),
        ),
        PaperItem(
          title: "IEB",
          brief: "IEB Examinations",
          section: Section(title: TileTopicsP1Data.examIebTitle, topics: TileTopicsP1Data.iebExams),
        ),
      ];

  List<PaperItem> _paper2TileItems() => [
        PaperItem(
          title: "My Progress",
          brief: "Passing with flying colours",
          section: Section(title: TileTopicsP1Data.myProgressTitle, topics: TileTopicsP1Data.myProgress,),
        ),
        PaperItem(
          title: 'Class Notes',
          brief: 'Notes on every section',
          section: Section(title: TileTopicsP1Data.classNotesTitle, topics: TileTopicsP1Data.classNotes,),
        ),
        PaperItem(
          title: 'Practice Papers',
          brief: 'Practice makes perfect',
          section: Section(title: TileTopicsP1Data.practiceTitle,topics: TileTopicsP1Data.practicePapers,),
        ),
        PaperItem(
          title: 'March',
          brief: 'March Tests',
          section: Section(title: TileTopicsP1Data.marchTestsTitle, topics: TileTopicsP1Data.marchTests,), 
        ),
        PaperItem(
          title: 'June',
          brief: 'June Examinations',
          section: Section(title:  TileTopicsP1Data.examJuneTitle, topics: TileTopicsP1Data.juneExams,),
        ),
        PaperItem(
          title: 'Prelims',
          brief: 'Preliminary Examinations',
          section: Section(title: TileTopicsP1Data.examPrelimsTitle, topics: TileTopicsP1Data.prelimExams,), 
        ),
        PaperItem(
          title: 'November',
          brief: 'November Examinations',
          section: Section(title: TileTopicsP1Data.examNovemberTitle, topics: TileTopicsP1Data.novemberExams,),
        ),
        PaperItem(
          title: "IEB",
          brief: "IEB Examinations",
          section: Section(title: TileTopicsP1Data.examIebTitle, topics: TileTopicsP1Data.iebExams),
        ),
      ];

}
