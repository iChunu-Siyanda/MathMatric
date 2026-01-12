import 'dart:async';
import 'package:flutter/material.dart';

class AutoSlidingCarousel extends StatefulWidget {
  const AutoSlidingCarousel({super.key});

  @override
  State<AutoSlidingCarousel> createState() => _AutoSlidingCarouselState();
}

class _AutoSlidingCarouselState extends State<AutoSlidingCarousel> {
  final CarouselController _controller = CarouselController();

  Timer? _timer;
  bool _isPaused = false;

  //loop setup
  final int _originalItemCount = 5;
  late final int _totalItemCount;
  late final int _loopStartIndex;

  int _currentIndex = 0;

  static const _autoSlideDuration = Duration(seconds: 5);
  static const _animationDuration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();

    // Duplicate items before and after
    _totalItemCount = _originalItemCount * 3;
    _loopStartIndex = _originalItemCount;

    _currentIndex = _loopStartIndex;

    // Jump to middle set after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _instantJump(_currentIndex);
    });

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoSlideDuration, (_) async {
      if (_isPaused) return;

      _currentIndex++;

      await _controller.animateToItem(
        _currentIndex,
        duration: _animationDuration,
        curve: Curves.easeInOutCubic,
      );

      _handleLoopBoundary();
    });
  }

  Future<void> _instantJump(int index) async {
    await _controller.animateToItem(
      index,
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
  }

  // recentering
  void _handleLoopBoundary() {
    final leftBoundary = _originalItemCount;
    final rightBoundary = _originalItemCount * 2;

    if (_currentIndex >= rightBoundary) {
      _currentIndex = leftBoundary;
      _instantJump(_currentIndex);
    } else if (_currentIndex < leftBoundary) {
      _currentIndex = rightBoundary - 1;
      _instantJump(_currentIndex);
    }
  }

  void _pause() => _isPaused = true;
  void _resume() => _isPaused = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: MouseRegion(
          onEnter: (_) => _pause(),
          onExit: (_) => _resume(),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (_) => _pause(),
            onPanDown: (_) => _pause(),
            onTapUp: (_) => _resume(),
            onPanEnd: (_) => _resume(),
            onPanCancel: _resume,
            child: SizedBox(
              height: 170,
              child: CarouselView.weighted(
                controller: _controller,
                flexWeights: const [3, 1],
                shrinkExtent: 50,
                itemSnapping: true,
                children: List.generate(_totalItemCount, (index) {
                  final realIndex = index % _originalItemCount;
                  return _CarouselCard(index: realIndex, colors: colors);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final int index;
  final ColorScheme colors;

  const _CarouselCard({required this.index, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha:.18), blurRadius: 6, offset: const Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Text(
          'Card ${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
