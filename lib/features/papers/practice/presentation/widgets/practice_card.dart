import 'package:flutter/material.dart';

class PracticeCard extends StatefulWidget {
  final String imageUrl;
  final String memoText;

  const PracticeCard({
    super.key,
    required this.imageUrl,
    required this.memoText,
  });

  @override
  State<PracticeCard> createState() => _PracticeCardState();
}

class _PracticeCardState extends State<PracticeCard> {
  bool isMemoVisible = false;
  bool isLiked = false;

  void toggleMemo() {
    setState(() {
      isMemoVisible = !isMemoVisible;
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // IMAGE WITH DOUBLE TAP
          GestureDetector(
            onDoubleTap: toggleLike,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                if (isLiked)
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 60,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // TITLE
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Question 1 - Algebra",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // MEMO (ANIMATED)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.memoText,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            crossFadeState: isMemoVisible
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),

          const SizedBox(height: 10),

          // BUTTON (MOVES DOWN NATURALLY)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: toggleMemo,
                child: Text(isMemoVisible ? "Hide Memo" : "View Memo"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}