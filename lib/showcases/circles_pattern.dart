import 'dart:math' as math;
import 'package:flutter/material.dart';

class CirclesPatternShowcase extends StatefulWidget {
  const CirclesPatternShowcase({super.key});

  @override
  State<CirclesPatternShowcase> createState() => _CirclesPatternShowcaseState();
}

class _CirclesPatternShowcaseState extends State<CirclesPatternShowcase>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          key: const Key('circles-pattern'),
          painter: _CirclesPatternPainter(_animation),
          willChange: true,
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _CirclesPatternPainter extends CustomPainter {
  final Animation<double> animation;
  static const Iterable<Color> gradientColors = [
    Colors.brown,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.cyan,
    Colors.indigo,
    Colors.purple,
  ];

  _CirclesPatternPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final opacityInterval = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.1),
    );
    final distanceInterval = CurvedAnimation(
      parent: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.20, 0.9),
      ),
      curve: Curves.elasticInOut,
    );

    canvas.translate(
      size.width / 2,
      size.height / 2,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = Tween<double>(
        begin: 3,
        end: 1.75,
      ).animate(animation).value
      ..shader = RadialGradient(
        colors: gradientColors
            .map((e) => e.withOpacity(opacityInterval.value))
            .toList(),
        radius: Tween<double>(
          begin: 0.9,
          end: 0.39,
        ).animate(animation).value,
      ).createShader(
        Rect.fromCircle(
          center: Offset.zero,
          radius: size.width / 2,
        ),
      )
      ..isAntiAlias = true; // !kDebugMode

    final circleCount = 33 * animation.value;
    final radianStep = (math.pi * 2) / circleCount;

    for (var i = 0; i < circleCount; i++) {
      final offset = Offset.fromDirection(
        radianStep * i + (math.pi * 2 * animation.value),
        Tween<double>(begin: 70, end: 130).animate(distanceInterval).value,
      );

      canvas.drawCircle(offset, 100, paint);
    }
  }

  @override
  bool shouldRepaint(_CirclesPatternPainter oldDelegate) => true;
}
