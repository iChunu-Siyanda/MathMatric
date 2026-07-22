import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class ViewButton extends StatefulWidget {
  final VoidCallback onTap;

  const ViewButton({
    super.key, 
    required this.onTap,
  });

  @override
  State<ViewButton> createState() => _ViewButtonState();
}

class _ViewButtonState extends State<ViewButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColours.primaryAccent
              : AppColours.surface.withAlpha(180),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: _hovered
                ? AppColours.primaryAccent
                : AppColours.primaryAccent.withAlpha(50),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColours.primaryAccent.withAlpha(35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View',
                    style: TextStyle(
                      color: _hovered
                          ? AppColours.surface
                          : AppColours.primaryAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 4),

                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: _hovered
                        ? AppColours.surface
                        : AppColours.primaryAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
