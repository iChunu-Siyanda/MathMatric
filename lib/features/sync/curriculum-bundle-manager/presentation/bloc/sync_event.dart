sealed class SyncEvent {
  const SyncEvent();
}

final class CheckForUpdates extends SyncEvent {
  const CheckForUpdates();
}

final class StartSynchronization extends SyncEvent {
  const StartSynchronization();
}

final class RetrySynchronization extends SyncEvent {
  const RetrySynchronization();
}

final class ClearLocalContent extends SyncEvent {
  const ClearLocalContent();
}

// class DownloadEmbeddings extends SyncEvent {}

// class DownloadLocalModel extends SyncEvent {}

// class RestoreUserProgress extends SyncEvent {}
