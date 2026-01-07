import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/models/paper_item.dart';

class SectionType extends StatefulWidget {
  final String pageTitle;
  final List<String> tabTitles;
  final List<Widget> tabPages;
  final PaperItem ? content;

  const SectionType({super.key, required this.tabPages, required this.tabTitles, required this.pageTitle, this.content});

  @override
  State<SectionType> createState() => _SectionTypeState();
}

class _SectionTypeState extends State<SectionType>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
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
              tabs: [
                for (final title in widget.tabTitles) Tab(text: title),
              ],
            ),
          )
        ],

        body: TabBarView(
          controller: _tabController,
          children: widget.tabPages
        ),
      ),
    );
  }
}
