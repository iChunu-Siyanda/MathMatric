import 'package:flutter/material.dart';

class ExamPaperViewer extends StatefulWidget {
  final List<String> pageAssets;
  final String title;

  const ExamPaperViewer({
    super.key,
    required this.pageAssets,
    required this.title,
  });

  @override
  State<ExamPaperViewer> createState() => _ExamPaperViewerState();
}

class _ExamPaperViewerState extends State<ExamPaperViewer> {
  // Toggle state
  bool isListView = true; // Start in vertical scroll mode
  int _currentPage = 1;

  // Controllers
  late PageController _pageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!isListView || !_scrollController.hasClients) return;
    
    // Logic to update page counter based on vertical scroll position
    final double offset = _scrollController.offset;
    final double itemHeight = MediaQuery.of(context).size.height * 0.8; // Estimate height
    final int page = (offset / itemHeight).round() + 1;

    if (page != _currentPage && page > 0 && page <= widget.pageAssets.length) {
      setState(() => _currentPage = page);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.pageAssets;

    return Scaffold(
      backgroundColor: Colors.grey[200], // Slight contrast for the webp pages
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Text(
              isListView ? "Scroll View" : "Book View",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // THE TOGGLE BUTTON
          IconButton(
            icon: Icon(
              isListView ? Icons.stay_primary_portrait : Icons.import_contacts,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
            tooltip: "Toggle View Mode",
          ),
        ],
      ),
      body: Stack(
        children: [
          isListView ? _buildListView(pages) : _buildPageView(pages),

          // Page indicator overlay
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha:0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_currentPage / ${pages.length}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal View
  Widget _buildPageView(List<String> pages) {
    return PageView.builder(
      controller: _pageController,
      itemCount: pages.length,
      onPageChanged: (index) => setState(() => _currentPage = index + 1),
      itemBuilder: (context, index) => _imageWrapper(pages[index]),
    );
  }

  // Vertical View
  Widget _buildListView(List<String> pages) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: pages.length,
      padding: const EdgeInsets.only(bottom: 100), // Space for indicator
      itemBuilder: (context, index) => _imageWrapper(pages[index]),
    );
  }

  // Helper to keep image styling consistent + Add Zoom
  Widget _imageWrapper(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InteractiveViewer( // UPGRADE: Allows users to pinch-zoom into the exam paper
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
