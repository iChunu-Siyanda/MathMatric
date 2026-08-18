class BundleInfoModel {
  final String id;
  final String subjectId;
  final int version;

  const BundleInfoModel({
    required this.id,
    required this.subjectId,
    required this.version, 
  });

  factory BundleInfoModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return BundleInfoModel(
      id: json['id'] as String,
      subjectId: json['subjectId'] as String,
      version: json['version'] as int,
    );
  }
}
