import 'package:math_matric/app/factories/topic_factory.dart';
import 'package:math_matric/app/navigation/section_tab_entities.dart';

class TabModel {
  final List<SectionTab> tabs;
  final TabType tabType;
  //final List<Widget> tabPages;

  const TabModel({
    required this.tabs,
    required this.tabType,
  });
}


