import 'package:math_matric/features/papers/domain/entities/paper_item.dart';

abstract class PapersState {
  const PapersState();
}

// Initial idle state
class PapersInitial extends PapersState {
  const PapersInitial();
}

// While loading assets / data
class PapersLoading extends PapersState {
  const PapersLoading();
}

// Successfully loaded a paper
class PapersLoaded extends PapersState {
  final PaperItem paper;

  const PapersLoaded(this.paper);
}

// Error state (missing asset, corrupted data, etc.)
class PapersError extends PapersState {
  final String message;

  const PapersError(this.message);
}
