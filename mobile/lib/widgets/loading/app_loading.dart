import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class AppLoading extends StatefulWidget {
  const AppLoading({super.key});
  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0x2600B0FF),
            blurRadius: 8,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Padding(padding: const EdgeInsets.only(left: 3, top: 0),child: MyAssets.images.iconPPinmall.svg(
          //   colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          // )),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: const GradientCircularProgressIndicator(
              radius: 23,
              gradientColors: [
                Color(0x0000B0FF),
                Color(0xFF9747FF),
              ],
              strokeWidth: 5.0,
            ),
          )
        ],
      ),
    );
  }
}

class GradientCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  const GradientCircularProgressIndicator({
    super.key,
    required this.radius,
    required this.gradientColors,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: GradientCircularProgressPainter(
        radius: radius,
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  GradientCircularProgressPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
  });
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius);
    double offset = strokeWidth / 2;
    Rect rect = Offset(offset, offset) & Size(size.width - strokeWidth, size.height - strokeWidth);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    paint.shader = SweepGradient(colors: gradientColors, startAngle: 0.0, endAngle: 2 * pi).createShader(rect);
    canvas.drawArc(rect, 0.0, 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
