import 'package:flutter/material.dart';

class TabModel {
  final List<String> tabTitles;
  final List<Widget> tabPages;

  const TabModel({
    required this.tabTitles,
    required this.tabPages,
  });
}
