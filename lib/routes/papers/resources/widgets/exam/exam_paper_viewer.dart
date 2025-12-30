import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class ExamPaperViewer extends StatefulWidget {
  final String pdfAssetPath;
  final String title;

  const ExamPaperViewer({
    super.key,
    required this.pdfAssetPath,
    required this.title,
  });

  @override
  State<ExamPaperViewer> createState() => _ExamPaperViewerState();
}

class _ExamPaperViewerState extends State<ExamPaperViewer> {
  late PdfControllerPinch _pdfController;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset(widget.pdfAssetPath),
      initialPage: 1,
    );

    // Load total pages
    _pdfController.document.then((doc) {
      setState(() {
        _totalPages = doc.pagesCount;
      });
    });

    _pdfController.addListener(() {
      final newPage = _pdfController.page;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: PdfViewPinch(
                  controller: _pdfController,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
          ),

          // Scroll position info
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
