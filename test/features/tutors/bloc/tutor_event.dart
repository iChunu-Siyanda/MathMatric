abstract class TutorEvent {
  const TutorEvent();
}

class LoadTutors extends TutorEvent {
  const LoadTutors();
}

class LoadMoreTutors extends TutorEvent {
  const LoadMoreTutors();
}

class RefreshTutors extends TutorEvent {
  const RefreshTutors();
}
