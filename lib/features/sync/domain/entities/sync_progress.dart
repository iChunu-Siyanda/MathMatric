import 'sync_status.dart';

class SyncProgress {
  final SyncStatus status;
  final double progress;
  final String message;

  const SyncProgress({
    required this.status,
    required this.progress,
    required this.message,
  });

  factory SyncProgress.idle() {
    return const SyncProgress(
      status: SyncStatus.idle,
      progress: 0,
      message: '',
    );
  }

  SyncProgress copyWith({
    SyncStatus? status,
    double? progress,
    String? message,
  }) {
    return SyncProgress(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      message: message ?? this.message,
    );
  }
}
