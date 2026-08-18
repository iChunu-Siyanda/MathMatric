sealed class SyncState {
  const SyncState();
}

final class SyncInitial extends SyncState {
  const SyncInitial();
}

final class SyncChecking extends SyncState {
  const SyncChecking();
}

final class SyncDownloading extends SyncState {
  final double progress;
  final String message;

  const SyncDownloading({
    required this.progress,
    required this.message,
  });
}

final class SyncCompleted extends SyncState {
  const SyncCompleted();
}

final class SyncUpToDate extends SyncState {
  const SyncUpToDate();
}

final class SyncFailure extends SyncState {
  final String error;

  const SyncFailure(this.error);
}
