import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/components/supporting/top_content_of_card.dart';
import 'package:math_matric/routes/papers/resources/models/paper_item_modal.dart';

class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.data,
  });

  final PaperItem data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      clipBehavior: Clip.antiAlias, // Needed for rounded image clipping
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // ---- Background Image ----
          Positioned.fill(
            child: Image.asset(
              "assets/images/algebra.jpg",
              fit: BoxFit.cover,
            ),
          ),
    
          // ---- Gradient for text readability ----
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),
    
          // ---- Card content on top ----
          TopContentOfCard(data: data, title: "Paper 1",),
        ],
      ),
    );
  }
}

