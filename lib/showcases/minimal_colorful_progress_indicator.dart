import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class MinimalProgressIndicatorShowcase extends StatefulWidget {
  const MinimalProgressIndicatorShowcase({super.key});

  @override
  State<MinimalProgressIndicatorShowcase> createState() =>
      _MinimalProgressIndicatorShowcaseState();
}

class _MinimalProgressIndicatorShowcaseState
    extends State<MinimalProgressIndicatorShowcase> {
  static const initialProgressValue = 0.0;
  Timer? _timer;
  double progressValue = initialProgressValue;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 900),
      (timer) {
        setState(() {
          if ((progressValue += 0.2) > 1.0) {
            progressValue = initialProgressValue;
          }
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0Xff222228),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints.expand(
                    width: 375,
                  ),
                  child: MinimalProgressIndicator(
                    progress: progressValue,
                    duration: const Duration(milliseconds: 600),
                  ),
                ),
              ),
              Text(
                '"Amir Mohammad Mashayekhi"\n'
                'github.com/amir-msh',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[800]!),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class MinimalProgressIndicator extends ImplicitlyAnimatedWidget {
  final double progress;
  final Curve animationCurve;
  final List<Color> indicatorColors;
  static const defaultIndicatorColors = [
    Color(0xfffaf030),
    Color(0xff60bd43),
    Color(0xffe12830),
    Color(0xff3f7aca),
    Color(0xfffaf030),
  ];

  const MinimalProgressIndicator({
    super.key,
    required super.duration,
    super.onEnd,
    required this.progress,
    this.animationCurve = Curves.easeInOut,
    this.indicatorColors = defaultIndicatorColors,
  })  : assert(indicatorColors.length >= 2),
        super(curve: Curves.linear);

  @override
  ImplicitlyAnimatedWidgetState<MinimalProgressIndicator> createState() =>
      MinimalProgressIndicatorState();
}

class MinimalProgressIndicatorState
    extends ImplicitlyAnimatedWidgetState<MinimalProgressIndicator> {
  Tween<double>? _loadingTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _loadingTween = visitor(
      _loadingTween,
      widget.progress,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  late CurvedAnimation curvedAnimation;

  @override
  void initState() {
    super.initState();

    curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: widget.animationCurve,
    );
  }

  @override
  void dispose() {
    curvedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: curvedAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: MinimalProgressIndicatorPainter(
              _loadingTween!.animate(curvedAnimation),
              indicatorColors: widget.indicatorColors,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
            ),
          );
        },
      ),
    );
  }
}

class MinimalProgressIndicatorPainter extends CustomPainter {
  final Animation<double> animation;
  final double padding;
  final String text;
  final List<Color> indicatorColors;

  const MinimalProgressIndicatorPainter(
    this.animation, {
    this.padding = 5,
    this.text = 'Mix',
    required this.indicatorColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final double shortestSide = size.shortestSide;
    final double shaderCircleRadius = (shortestSide / 2) - padding;
    const double progressArcStrokeWidth = 13;
    final double progressArcRadius =
        shaderCircleRadius - 15 - (progressArcStrokeWidth / 2);
    const double innerCirclePadding = 8;
    final double innerCircleRadius =
        progressArcRadius - (progressArcStrokeWidth / 2) - innerCirclePadding;
    const double shaderCircleBlurRadius = 35;

    drawShaderCircle(
      canvas,
      shaderCircleRadius,
      shaderCircleBlurRadius,
    );

    drawInnerCircle(
      canvas,
      innerCircleRadius,
    );

    drawText(
      canvas,
      size,
      innerCircleRadius - 5,
    );

    drawProgressArc(
      canvas,
      progressArcRadius,
      progressArcStrokeWidth,
    );
  }

  void drawShaderCircle(Canvas canvas, double circleRadius, double blurRadius) {
    final outerShaderPaint = Paint()
      ..imageFilter = ImageFilter.blur(
        sigmaX: blurRadius,
        sigmaY: blurRadius,
        tileMode: TileMode.decal,
      )
      ..filterQuality = FilterQuality.high
      ..shader = LinearGradient(
        colors: [
          Colors.grey[800]!.withOpacity(0.6),
          Colors.black.withOpacity(0.9),
          Colors.black.withOpacity(0.9),
        ],
        stops: const [0.4, 0.75, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromCircle(
          center: Offset.zero,
          radius: circleRadius,
        ),
      );

    canvas.drawCircle(
      Offset.zero,
      circleRadius * 1.05,
      outerShaderPaint,
    );
  }

  void drawInnerCircle(Canvas canvas, double circleRadius) {
    canvas.drawCircle(
      Offset.zero,
      circleRadius,
      Paint()
        ..color = const Color(0xff222228)
        ..style = PaintingStyle.fill,
    );
  }

  void drawProgressArc(Canvas canvas, double arcRadius, double arcStrokeWidth) {
    canvas.drawCircle(
      Offset.zero,
      arcRadius,
      Paint()
        ..color = const Color(0xff171719).withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcStrokeWidth,
    );

    if (animation.value == 0) return;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: indicatorColors,
        center: Alignment.center,
        transform: const GradientRotation(-pi / 2),
      ).createShader(
        Rect.fromCircle(
          center: Offset.zero,
          radius: arcRadius,
        ),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset.zero,
        radius: arcRadius,
      ),
      -pi / 2,
      animation.value * pi * 2,
      false,
      progressPaint,
    );
  }

  void drawText(
    Canvas canvas,
    Size size,
    double maxWidth,
  ) {
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.1),
      fontSize: 55,
      fontWeight: FontWeight.w700,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: maxWidth,
    );

    final offset = Offset(
      -textPainter.width / 2,
      -textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(
    covariant MinimalProgressIndicatorPainter oldDelegate,
  ) {
    return animation != oldDelegate.animation;
  }
}
