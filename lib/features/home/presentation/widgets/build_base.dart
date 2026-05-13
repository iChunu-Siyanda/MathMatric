import 'package:flutter/material.dart';

Widget buildBase({
  required String title,
  required String desc,
  required List<Color> colors,
  required IconData icon,
  required Widget trailing,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    // LayoutBuilder intercepts parent constraints before children can crash
    child: LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;

        // CRITICAL FIX: If the card shrinks into the flex '1' slot, drop the layout to a safe placeholder icon
        if (availableWidth < 140) {
          return Center(
            child: Icon(
              icon,
              size: availableWidth > 50 ? 40 : availableWidth * 0.6,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          );
        }

        // Standard responsive card view when width is wide enough (flex '7')
        return Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: availableWidth > 200
                    ? 120
                    : 80, // Safe responsive background icon scale
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(availableWidth > 220
                  ? 20.0
                  : 12.0), // Smaller padding on tight frames
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: availableWidth > 220
                                ? 22
                                : 16, // Adaptive text sizing
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: availableWidth > 220 ? 13 : 11,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Render the trailing badge/timer layout safely
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 60,
                      maxWidth: 60,
                    ),
                    child: Center(child: trailing),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}
