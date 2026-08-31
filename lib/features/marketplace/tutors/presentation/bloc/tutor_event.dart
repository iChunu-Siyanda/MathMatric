sealed class TutorEvent {
  const TutorEvent();
}

final class LoadTutors extends TutorEvent {
  const LoadTutors();
}

final class LoadMoreTutors extends TutorEvent {
  const LoadMoreTutors();
}

final class RefreshTutors extends TutorEvent {
  const RefreshTutors();
}
