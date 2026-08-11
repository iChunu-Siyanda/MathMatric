import 'package:math_matric/features/curriculum/exams/data/datasource/local/exam_paper_local_data_source.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';

class ExamPapersRepositoryImpl implements ExamPapersRepository {
  final ExamPaperLocalDataSource local;
  ExamPapersRepositoryImpl(this.local);

  @override
  Future<List<ExamPaperEntity>> getAllExamPapers() async {
    final models = await local.getAllExamPapers();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ExamPaperEntity?> getExamPaper(
    String paperId,
  ) async {
    final model = await local.getExamPaper(paperId);

    return model?.toEntity();
  }

  @override
  Future<List<ExamPaperEntity>> getExamPapersByType(
    String paperType,
  ) async {
    final models = await local.getExamPapersByType(paperType);

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getExamPapersByYear(
    int year,
  ) async {
    final models = await local.getExamPapersByYear(year);

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getExamPapersBySession(
    String session,
  ) async {
    final models = await local.getExamPapersBySession(session);

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getNationalExamPapers() async {
    final models = await local.getNationalExamPapers();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getProvincialExamPapers(
    String province,
  ) async {
    final models = await local.getProvincialExamPapers(province);

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getDownloadedExamPapers() async {
    final models = await local.getDownloadedExamPapers();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getMemoPapers() async {
    final models = await local.getMemoPapers();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ExamPaperEntity>> getChildPapers(
    String parentPaperId,
  ) async {
    final models = await local.getChildPapers(parentPaperId);

    return models.map((m) => m.toEntity()).toList();
  }
}
