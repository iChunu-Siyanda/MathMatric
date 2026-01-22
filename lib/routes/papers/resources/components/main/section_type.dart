import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/models/section_context_modal.dart';
import 'package:math_matric/routes/papers/resources/models/section_tab_modal.dart';

class SectionType extends StatefulWidget {
  final String pageTitle;
  final List<SectionTab> tabs;
  final SectionContext sectionContext;

  const SectionType({
    super.key,
    required this.pageTitle,
    required this.tabs,
    required this.sectionContext,
  });

  @override
  State<SectionType> createState() => _SectionTypeState();
}

class _SectionTypeState extends State<SectionType>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, innerBox) => [
          SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight: 120,
            centerTitle: true,
            title: Text(widget.pageTitle),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: const Color.fromARGB(179, 97, 95, 95),
              indicatorColor: Colors.black,
              tabs: widget.tabs.map((t) => Tab(text: t.title)).toList(),
            ),
          ),
        ],

        body: TabBarView(
          controller: _tabController,
          children: widget.tabs.map((t) => t.builder(widget.sectionContext)).toList(),
        ),
      ),
    );
  }
}
