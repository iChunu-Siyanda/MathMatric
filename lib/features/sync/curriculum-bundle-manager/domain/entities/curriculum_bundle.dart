import 'package:math_matric/features/curriculum/exams/data/models/exam_paper_model.dart';
import 'package:math_matric/features/curriculum/levels/data/models/levels_model.dart';
import 'package:math_matric/features/curriculum/questions/data/models/questions_model.dart';
import 'package:math_matric/features/curriculum/subjects/data/models/subjects_model.dart';
import 'package:math_matric/features/curriculum/topics/data/models/topic_model.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/models/bundle_info_model.dart';

class CurriculumBundle {
  final BundleInfoModel info;
  final List<SubjectsModel> subjects;
  final List<TopicModel> topics;
  final List<LevelsModel> levels;
  final List<QuestionsModel> questions;
  final List<ExamPaperModel> examPapers;

  const CurriculumBundle({
    required this.info,
    required this.subjects,
    required this.topics,
    required this.levels,
    required this.questions,
    required this.examPapers,
  });
}
