import 'dart:async';
import 'package:flutter/material.dart';
import 'package:math_matric/features/home/presentation/widgets/smart_carousel_card.dart';

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
  final int _originalItemCount = 4;
  int _currentIndex = 1000;
  late bool _isAnimating;

  static const _autoSlideDuration = Duration(seconds: 5);
  static const _animationDuration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.animateToItem(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
      );
    });

    _isAnimating = false;

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoSlideDuration, (_) async {
      if (_isPaused || _isAnimating || !mounted) return;
      _isAnimating = true;
      _currentIndex++;

      await _controller.animateToItem(
        _currentIndex,
        duration: _animationDuration,
        curve: Curves.easeInOutCubic,
      );
      if (!mounted) return;

      _isAnimating = false;
    });
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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
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
              height: 190,
              child: CarouselView.weighted(
                controller: _controller,
                flexWeights: const [7, 1],
                shrinkExtent: 100,
                itemSnapping: true,
                children: List.generate(20000, (index) {
                  final realIndex = index % _originalItemCount;
                  return SmartCarouselCard(
                      typeIndex: realIndex);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
