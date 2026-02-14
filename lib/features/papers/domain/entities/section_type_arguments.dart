import 'package:math_matric/app/factories/topic_factory.dart';
import 'package:math_matric/app/navigation/section_context_modal.dart';
import 'package:math_matric/app/navigation/section_tab_entities.dart';

class SectionTypeArguments {
  final String pageTitle;
  final TabType tabType;
  final List<SectionTab> tabs;
  final SectionContext sectionContext;

  SectionTypeArguments({
    required this.pageTitle,
    required this.tabType,
    required this.tabs,
    required this.sectionContext
  });
}