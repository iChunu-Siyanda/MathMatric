class SyncResult {
  final int attemptsSynced;
  final int topicProgressSynced;
  final int levelProgressSynced;
  final int sessionsSynced;

  final bool success;

  const SyncResult({
    required this.attemptsSynced,
    required this.topicProgressSynced,
    required this.levelProgressSynced,
    required this.sessionsSynced,
    required this.success,
  });
}

// This doesn't need its own sync page.
// Keep it largely invisible:
// Online
//    ↓
// SyncCoordinator
//    ↓
// Upload pending data
//    ↓
// Done

// At most, have a small indicator somewhere:

// ☁ Synced

// or

// ☁ Syncing...

// or

// ⚠ Sync pending