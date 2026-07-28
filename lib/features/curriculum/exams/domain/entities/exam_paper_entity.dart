class ExamPaperEntity {
  final String id;
  final String? parentPaperId;

  final String paperType;
  final String session;
  final String title;
  final bool isMemo;

  final String storagePath;
  final String? province;
  final bool isNational;
  final int year;
  final int pageCount;

  final bool downloaded;

  const ExamPaperEntity({
    required this.id,
    this.parentPaperId,
    required this.paperType,
    required this.session,
    required this.title,
    required this.isMemo,
    required this.storagePath,
    this.province,
    required this.isNational,
    required this.year,
    required this.pageCount,
    required this.downloaded,
  });
}
