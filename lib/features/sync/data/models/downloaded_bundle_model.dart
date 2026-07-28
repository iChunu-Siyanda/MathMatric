import 'package:math_matric/core/database/app_database.dart';

class DownloadedBundleModel {
  final String id;
  final int version;
  final DateTime downloadedAt;

  const DownloadedBundleModel({
    required this.id,
    required this.version,
    required this.downloadedAt,
  });

  factory DownloadedBundleModel.fromFirestore(
    Map<String, dynamic> json,
  ) {
    return DownloadedBundleModel(
      id: json['id'] as String,
      version: json['version'] as int,
      downloadedAt: DateTime.parse(
        json['downloadedAt'] as String,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'version': version,
      'downloadedAt': downloadedAt.toIso8601String(),
    };
  }

  factory DownloadedBundleModel.fromDrift(
    DownloadedBundleData bundle,
  ) {
    return DownloadedBundleModel(
      id: bundle.id,
      version: bundle.version,
      downloadedAt: bundle.downloadedAt,
    );
  }

  DownloadedBundleCompanion toCompanion() {
    return DownloadedBundleCompanion.insert(
      id: id,
      version: version,
      downloadedAt: downloadedAt,
    );
  }
}
