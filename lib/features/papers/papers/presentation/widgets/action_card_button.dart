import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class ActionCardButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const ActionCardButton({
    super.key, 
    required this.label,
    required this.onTap,
  });

  @override
  State<ActionCardButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionCardButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: _hover
              ? AppColours.primaryAccent
              : AppColours.surface.withAlpha(210),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover
                ? AppColours.primaryAccent
                : AppColours.border,
          ),
          boxShadow: _hover
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
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: _hover
                          ? AppColours.surface
                          : AppColours.primaryAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: _hover
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
