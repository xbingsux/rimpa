import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class GradiantButton extends StatelessWidget {
  final double height;
  final double radius;
  final double width;
  final VoidCallback onTap;
  final String text;
  final Gradient gradient;
  bool disble;

  GradiantButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 48,
    this.width = double.infinity,
    this.radius = 20,
    this.gradient = AppGradiant.gradientX_1,
    this.disble = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disble ? null : onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.zero, // ใช้ padding 0 เพราะเราจะกำหนดใน Container
        backgroundColor: Colors.transparent, // ใช้ Gradient แทนสีพื้นหลัง
        shadowColor: Colors.transparent, // ปิดเงาเพื่อให้ Gradient ชัดขึ้น
      ),
      child: Ink(
        decoration: !disble
            ? BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(radius),
              )
            : BoxDecoration(
                color: AppTextColors.secondary,
                borderRadius: BorderRadius.circular(radius),
              ),
        child: Container(
          width: width,
          constraints: BoxConstraints(minHeight: height, maxHeight: height),
          alignment: Alignment.center,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: AppTextSize.md,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

class RimpaButton extends StatelessWidget {
  final double height;
  final double radius;
  final double width;
  final Color buttonColor;
  final VoidCallback onTap;
  final String text;
  bool disble;

  RimpaButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 48,
    this.width = double.infinity,
    this.radius = 20,
    this.buttonColor = AppColors.primary,
    this.disble = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disble ? null : onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.zero, // ใช้ padding 0 เพราะเราจะกำหนดใน Container
        backgroundColor: Colors.transparent, // ใช้ Gradient แทนสีพื้นหลัง
        shadowColor: Colors.transparent, // ปิดเงาเพื่อให้ Gradient ชัดขึ้น
      ),
      child: Ink(
        decoration: BoxDecoration(
          // gradient: AppGradiant.gradientX_1,
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(width: 1, color: disble ? AppTextColors.secondary : buttonColor),
        ),
        child: Container(
          width: width,
          constraints: BoxConstraints(minHeight: height, maxHeight: height),
          alignment: Alignment.center,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: disble ? AppTextColors.secondary : buttonColor,
                  fontSize: AppTextSize.md,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
