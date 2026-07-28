class BundleInfoModel {
  final String id;
  final int version;

  const BundleInfoModel({
    required this.id,
    required this.version,
  });

  factory BundleInfoModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return BundleInfoModel(
      id: json['id'] as String,
      version: json['version'] as int,
    );
  }
}
