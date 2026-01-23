import 'package:math_matric/features/papers/domain/entities/paper_type.dart';

abstract class PapersEvent {
  const PapersEvent();
}

// Fired when the user selects Paper 1 or Paper 2
class LoadPaperRequested extends PapersEvent {
  final PaperType paperType;

  const LoadPaperRequested(this.paperType);
}

// Optional: if you want to reset state when leaving page
class ResetPapers extends PapersEvent {
  const ResetPapers();
}

//One clear intent: “Load this paper”.