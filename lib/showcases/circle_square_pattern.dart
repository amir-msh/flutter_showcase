import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircleSquarePatternShowcase extends StatefulWidget {
  const CircleSquarePatternShowcase({super.key});

  @override
  State<CircleSquarePatternShowcase> createState() =>
      _CircleSquarePatternShowcaseState();
}

class _CircleSquarePatternShowcaseState
    extends State<CircleSquarePatternShowcase>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
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
          key: const Key('circle-square-pattern'),
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
      curve: Curves.bounceInOut,
    );
    final borderRadiusInterval = CurvedAnimation(
      parent: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.20, 0.9),
      ),
      curve: Curves.bounceInOut,
    );
    final rotateInterval = CurvedAnimation(
      parent: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.75, 0.999),
      ),
      curve: Curves.easeInOut,
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

    final circleCount = 32 * animation.value;
    final radianStep = (math.pi * 2) / circleCount;

    for (var i = 0; i < circleCount; i++) {
      final offset = Offset.fromDirection(
        radianStep * i + (math.pi * 2 * animation.value),
        Tween<double>(begin: 70, end: 160).animate(distanceInterval).value,
      );

      final path = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCircle(center: offset, radius: 100),
            Radius.circular(
              Tween<double>(begin: 200, end: 75)
                  .animate(borderRadiusInterval)
                  .value,
            ),
          ),
        );

      final transformMatrix = Matrix4.identity()
        ..rotateZ(
          Tween<double>(begin: math.pi / 2, end: 0)
              .animate(rotateInterval)
              .value,
        );

      canvas.drawPath(
        path.transform(transformMatrix.storage),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CirclesPatternPainter oldDelegate) => true;
}
