import 'package:math_matric/features/papers/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/presentation/navigation/section_context_modal.dart';

class ExamPageArguments {
  final PaperType paperType;
  final ExamPageMode mode;
  final SectionContext contextData;

  ExamPageArguments({
    required this.paperType,
    required this.mode,
    required this.contextData,
  });
}
