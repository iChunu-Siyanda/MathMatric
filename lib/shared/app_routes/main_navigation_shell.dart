import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

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
  // Flag to manage bottom nav visibility
  bool _isNavBarVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Wrap the shell in a NotificationListener to detect scrolling anywhere in child views
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) { //No need for Scroll controllers
          if (notification.direction == ScrollDirection.reverse) {
            // User scrolled down -> Hide navigation bar
            if (_isNavBarVisible) {
              setState(() {
                _isNavBarVisible = false;
              });
            }
          } else if (notification.direction == ScrollDirection.forward) {
            // User scrolled up -> Show navigation bar
            if (!_isNavBarVisible) {
              setState(() {
                _isNavBarVisible = true;
              });
            }
          }
          return true;
        },
        child: widget.navigationShell,
      ),

      // 2. Animate the bottom navigation bar sliding down/up
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        // Offset (0, 0) is default position, Offset (0, 1) slides down completely off-screen
        offset: _isNavBarVisible ? Offset.zero : const Offset(0, 1),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isNavBarVisible ? 1.0 : 0.0,
          child: NavigationBar(
            selectedIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: (int index) {
              // Ensure bar stays visible when switching tabs
              if (!_isNavBarVisible) {
                setState(() => _isNavBarVisible = true);
              }
              widget.navigationShell.goBranch(
                index,
                initialLocation: index == widget.navigationShell.currentIndex,
              );
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded,),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school_rounded),
                label: 'Tutors',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Must learn!!