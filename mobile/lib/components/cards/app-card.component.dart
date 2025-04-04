import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class AppCardComponent extends StatelessWidget {
  final double aspectRatio;
  final EdgeInsets incardPadding;
  final EdgeInsets outcardPadding;
  final Border border;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final BoxShadow boxShadow;
  final Widget child;
  const AppCardComponent(
      {super.key,
      this.aspectRatio = 2 / 3,
      this.incardPadding = const EdgeInsets.all(AppSpacing.sm),
      this.outcardPadding = const EdgeInsets.all(0),
      this.border = const Border.fromBorderSide(
          BorderSide(width: 1, color: AppColors.secondary)),
      this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.sm)),
      this.backgroundColor = AppColors.white,
      this.boxShadow = const BoxShadow(
        color: Colors.transparent, // สีเงาที่ใช้
        offset: Offset(0, 0), // การขยับเงา (ขยับไปทางขวาและลง)
        blurRadius: 0, // ความเบลอของเงา
        spreadRadius: 0, // การขยายของเงา
      ),
      required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: outcardPadding,
        child: Container(
          padding: incardPadding,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // ใช้สีจาก Theme
              borderRadius: borderRadius,
              border: border,
              boxShadow: [boxShadow]
          ),
          child: child,
        ),
      ),
    );
  }
}
