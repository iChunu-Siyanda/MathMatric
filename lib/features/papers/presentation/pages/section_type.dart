import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/data/respositories/exam_repository_impl.dart';
import 'package:math_matric/features/papers/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_bloc.dart';
import 'package:math_matric/features/papers/presentation/navigation/section_context_modal.dart';
import 'package:math_matric/features/papers/presentation/navigation/section_tab_entities.dart';

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
    final localExamDataSource = ExamPaperData();
    final repository = ExamPaperRepositoryImpl(localExamDataSource);
    final getExamPaperData = GetExamPaperData(repository);

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

        body: BlocProvider(
          create: (_) => ExamBloc(getExamPaperData),
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((t) => t.builder(widget.sectionContext)).toList(),
          ),
        ),
      ),
    );
  }
}
