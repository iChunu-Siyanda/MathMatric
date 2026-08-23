import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/home/domain/entities/last_studied.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_bloc.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_event.dart';

class ExamPaperViewer extends StatefulWidget {
  final List<String> pagePaths;
  final String title;

  const ExamPaperViewer({
    super.key,
    required this.pagePaths,
    required this.title,
  });

  @override
  State<ExamPaperViewer> createState() => _ExamPaperViewerState();
}

class _ExamPaperViewerState extends State<ExamPaperViewer> {
  // View mode
  bool isListView = true;

  // Current page
  int _currentPage = 1;

  // Controllers
  late final PageController _pageController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.pagePaths.isEmpty) return;

      _syncProgressToBloc(1);
    });
  }

  // ---------------------------------------------------------------------------
  // SCROLLING
  // ---------------------------------------------------------------------------

  void _onScroll() {
    if (!isListView || !_scrollController.hasClients) return;

    final double offset = _scrollController.offset;

    final double itemHeight =
        MediaQuery.of(context).size.height * 0.8;

    final int page =
        (offset / itemHeight).round() + 1;

    if (page != _currentPage &&
        page > 0 &&
        page <= widget.pagePaths.length) {
      setState(() {
        _currentPage = page;
      });
    }

    _syncProgressToBloc(page);
  }

  // ---------------------------------------------------------------------------
  // STUDY HISTORY
  // ---------------------------------------------------------------------------

  void _syncProgressToBloc(int page) {
    if (widget.pagePaths.isEmpty) return;

    if (page < 1) {
      page = 1;
    }

    if (page > widget.pagePaths.length) {
      page = widget.pagePaths.length;
    }

    final double progress =
        page / widget.pagePaths.length;

    context.read<StudyHistoryBloc>().add(
      TopicAccessed(
        LastStudied(
          title: widget.title,
          assets: widget.pagePaths,
          backgroundImg: widget.pagePaths.first,
          progress: progress,
          lastPage: page,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final pages = widget.pagePaths;

    return Scaffold(
      backgroundColor: Colors.grey[200],

      // -----------------------------------------------------------------------
      // APP BAR
      // -----------------------------------------------------------------------

      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,

        title: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            Text(
              isListView
                  ? 'Scroll View'
                  : 'Book View',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),

        actions: [
          IconButton(
            icon: Icon(
              isListView
                  ? Icons.stay_primary_portrait
                  : Icons.import_contacts,
              color: Colors.blueAccent,
            ),
            tooltip: 'Toggle View Mode',
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // BODY
      // -----------------------------------------------------------------------

      body: pages.isEmpty
          ? const Center(
              child: Text(
                'No pages available.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            )
          : Stack(
              children: [
                isListView
                    ? _buildListView(pages)
                    : _buildPageView(pages),

                _buildPageIndicator(pages.length),
              ],
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // PAGE INDICATOR
  // ---------------------------------------------------------------------------

  Widget _buildPageIndicator(int pageCount) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$_currentPage / $pageCount',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HORIZONTAL BOOK VIEW
  // ---------------------------------------------------------------------------

  Widget _buildPageView(List<String> pages) {
    return PageView.builder(
      controller: _pageController,
      itemCount: pages.length,

      onPageChanged: (index) {
        final pageNumber = index + 1;

        setState(() {
          _currentPage = pageNumber;
        });

        _syncProgressToBloc(pageNumber);
      },

      itemBuilder: (context, index) {
        return _imageWrapper(
          pages[index],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // VERTICAL SCROLL VIEW
  // ---------------------------------------------------------------------------

  Widget _buildListView(List<String> pages) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: pages.length,

      padding: const EdgeInsets.only(
        bottom: 100,
      ),

      itemBuilder: (context, index) {
        return _imageWrapper(
          pages[index],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // IMAGE
  // ---------------------------------------------------------------------------

  Widget _imageWrapper(String pagePath) {
    final file = File(pagePath);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),

        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 4.0,

          child: Image.file(
            file,
            fit: BoxFit.contain,

            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                height: 500,
                alignment: Alignment.center,
                color: Colors.white,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Unable to load this page.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
