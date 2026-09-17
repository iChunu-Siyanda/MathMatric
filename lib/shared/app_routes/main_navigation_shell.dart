import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/shared/widgets/navigation_destination_item.dart';

class MainNavigationShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  bool _isNavBarVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      extendBody: true, // Crucial for floating/glassmorphic effect
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (_isNavBarVisible) {
              setState(() => _isNavBarVisible = false);
            }
          } else if (notification.direction == ScrollDirection.forward) {
            if (!_isNavBarVisible) {
              setState(() => _isNavBarVisible = true);
            }
          }
          return true;
        },
        child: widget.navigationShell,
      ),
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        offset: _isNavBarVisible ? Offset.zero : const Offset(0, 1.2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isNavBarVisible ? 1.0 : 0.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColours.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColours.surfaceSecondary.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A2563EB), // Ambient glow using cobaltBlue
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NavDestinationItem(
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home_rounded,
                        label: 'Home',
                        isSelected: widget.navigationShell.currentIndex == 0,
                        onTap: () => _onTabSelected(0),
                      ),
                      NavDestinationItem(
                        icon: Icons.school_outlined,
                        selectedIcon: Icons.school_rounded,
                        label: 'Tutors',
                        isSelected: widget.navigationShell.currentIndex == 1,
                        onTap: () => _onTabSelected(1),
                      ),
                      NavDestinationItem(
                        icon: Icons.groups_outlined,
                        selectedIcon: Icons.groups_rounded,
                        label: 'Masterclasses',
                        isSelected: widget.navigationShell.currentIndex == 2,
                        onTap: () => _onTabSelected(2),
                      ),
                      NavDestinationItem(
                        icon: Icons.receipt_long_outlined,
                        selectedIcon: Icons.receipt_long_rounded,
                        label: 'History',
                        isSelected: widget.navigationShell.currentIndex == 3,
                        onTap: () => _onTabSelected(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTabSelected(int index) {
    if (!_isNavBarVisible) {
      setState(() => _isNavBarVisible = true);
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
