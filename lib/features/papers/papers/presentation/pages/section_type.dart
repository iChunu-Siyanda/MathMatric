import 'package:flutter/material.dart';
import 'package:math_matric/shared/entities/section_context_modal.dart';
import 'package:math_matric/shared/entities/section_tab_entities.dart';
import 'package:math_matric/theme/app_colours.dart'; 

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
      length: widget.tabs.length, // Dynamic length based on provided tabs
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: AppColours.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            floating: false,
            pinned: true,
            expandedHeight: 120,
            centerTitle: true,
            title: Text(
              widget.pageTitle,
              style: const TextStyle(
                color: AppColours.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColours.border,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColours.primaryAccent,
                  unselectedLabelColor: AppColours.textSecondary,
                  indicatorColor: AppColours.primaryAccent,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  tabs: widget.tabs.map((t) => Tab(text: t.title)).toList(),
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: widget.tabs
              .map((t) => t.builder(widget.sectionContext))
              .toList(),
        ),
      ),
    );
  }
}
