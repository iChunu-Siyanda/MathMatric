import 'package:math_matric/shared/entities/section_tab_entities.dart';
import 'package:math_matric/shared/entities/tab_type.dart';

class TabModel {
  final List<SectionTab> tabs;
  final TabType tabType;
  //final List<Widget> tabPages;

  const TabModel({
    required this.tabs,
    required this.tabType,
  });
}


