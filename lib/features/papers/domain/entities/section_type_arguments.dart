import 'package:math_matric/shared/navigation/section_context_modal.dart';
import 'package:math_matric/shared/navigation/section_tab_entities.dart';
import 'package:math_matric/shared/navigation/tab_type.dart';

class SectionTypeArguments {
  final String pageTitle;
  final String ? topicId;
  final TabType tabType;
  final List<SectionTab> tabs;
  final SectionContext sectionContext;

  SectionTypeArguments({
    required this.pageTitle,
    required this.tabType,
    required this.tabs,
    required this.sectionContext,
    this.topicId,
  });
}