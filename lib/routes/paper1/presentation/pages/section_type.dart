import 'package:flutter/material.dart';
import 'package:math_matric/routes/paper1/presentation/components/exam/exam_memo_page.dart';
import 'package:math_matric/routes/paper1/presentation/components/exam/exam_model.dart';
import 'package:math_matric/routes/paper1/presentation/components/exam/exam_paper_page.dart';

class SectionType extends StatefulWidget {
  final ExamModel exam;
  final String type1;
  final String type2;

  const SectionType({super.key, required this.exam, required this.type1, required this.type2});

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
            title: Text("${widget.exam.year} Exam"), 
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: widget.type1),
                Tab(text: widget.type2),
              ],
            ),
          )
        ],

        body: TabBarView(
          controller: _tabController,
          children: [
            ExamPaperPage(pdfPath: widget.exam.questionPdf),
            ExamMemoPage(pdfPath: widget.exam.memoPdf),
          ],
        ),
      ),
    );
  }
}
