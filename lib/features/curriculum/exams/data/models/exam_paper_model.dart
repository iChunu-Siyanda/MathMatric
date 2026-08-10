import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/curriculum/exams/domain/entities/exam_paper_entity.dart';

class ExamPaperModel extends ExamPaperEntity {
  final int version;

  const ExamPaperModel({
    required super.id,
    super.parentPaperId,
    required super.paperType,
    required super.session,
    required super.title,
    required super.isMemo,
    required super.storagePath,
    super.province,
    required super.isNational,
    required super.year,
    required super.pageCount,
    super.downloaded,
    required this.version,
  });

  factory ExamPaperModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return ExamPaperModel(
      id: json['id'] as String,
      parentPaperId: json['parentPaperId'] as String?,
      paperType: json['paperType'] as String,
      session: json['session'] as String,
      title: json['title'] as String,
      isMemo: json['isMemo'] as bool,
      storagePath: json['storagePath'] as String,
      province: json['province'] as String?,
      isNational: json['isNational'] as bool,
      year: json['year'] as int,
      pageCount: json['pageCount'] as int,
      //downloaded: json['downloaded'] as bool? ?? false,
      version: json['version'] as int,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'parentPaperId': parentPaperId,
      'paperType': paperType,
      'session': session,
      'title': title,
      'isMemo': isMemo,
      'storagePath': storagePath,
      'province': province,
      'isNational': isNational,
      'year': year,
      'pageCount': pageCount,
      //'downloaded': downloaded,
      'version': version,
    };
  }

  ExamPaperEntity toEntity() {
    return ExamPaperEntity(
      id: id,
      parentPaperId: parentPaperId,
      paperType: paperType,
      session: session,
      title: title,
      isMemo: isMemo,
      storagePath: storagePath,
      province: province,
      isNational: isNational,
      year: year,
      pageCount: pageCount,
      downloaded: downloaded,
    );
  }

  factory ExamPaperModel.fromEntity(
    ExamPaperEntity paper, {
    required int version,
  }) {
    return ExamPaperModel(
      id: paper.id,
      parentPaperId: paper.parentPaperId,
      paperType: paper.paperType,
      session: paper.session,
      title: paper.title,
      isMemo: paper.isMemo,
      storagePath: paper.storagePath,
      province: paper.province,
      isNational: paper.isNational,
      year: paper.year,
      pageCount: paper.pageCount,
      downloaded: paper.downloaded,
      version: version,
    );
  }

  factory ExamPaperModel.fromDrift(
    ExamPaper paper,
  ) {
    return ExamPaperModel(
      id: paper.id,
      parentPaperId: paper.parentPaperId,
      paperType: paper.paperType,
      session: paper.session,
      title: paper.title,
      isMemo: paper.isMemo,
      storagePath: paper.storagePath,
      province: paper.province,
      isNational: paper.isNational,
      year: paper.year,
      pageCount: paper.pageCount,
      downloaded: paper.downloaded,
      version: paper.version,
    );
  }

  ExamPapersCompanion toCompanion() {
    return ExamPapersCompanion.insert(
      id: id,
      parentPaperId: Value(parentPaperId),
      paperType: paperType,
      session: session,
      title: title,
      isMemo: isMemo,
      storagePath: storagePath,
      province: Value(province),
      isNational: isNational,
      year: year,
      pageCount: pageCount,
      version: version,
      downloaded: downloaded!,
    );
  }
}
