import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WatchlistLoadingShimmer extends StatefulWidget {
  const WatchlistLoadingShimmer({super.key});

  @override
  State<WatchlistLoadingShimmer> createState() =>
      _WatchlistLoadingShimmerState();
}

class _WatchlistLoadingShimmerState extends State<WatchlistLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => ListView.separated(
        itemCount: 8,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, __) => _ShimmerTile(opacity: _animation.value),
      ),
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  final double opacity;
  const _ShimmerTile({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _Box(width: 44, height: 44, radius: 10, opacity: opacity),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Box(width: 80, height: 14, radius: 4, opacity: opacity),
                const SizedBox(height: 6),
                _Box(width: 140, height: 11, radius: 4, opacity: opacity),
                const SizedBox(height: 6),
                _Box(width: 60, height: 10, radius: 4, opacity: opacity),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Box(width: 72, height: 14, radius: 4, opacity: opacity),
              const SizedBox(height: 6),
              _Box(width: 72, height: 32, radius: 6, opacity: opacity),
            ],
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double opacity;

  const _Box({
    required this.width,
    required this.height,
    required this.radius,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.darkDivider.withOpacity(opacity),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
