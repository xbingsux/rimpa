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
  final Widget child;
  const AppCardComponent(
      {super.key,
      this.aspectRatio = 2 / 3,
      this.incardPadding = const EdgeInsets.all(AppSpacing.sm),
      this.outcardPadding = const EdgeInsets.all(0),
      this.border = const Border.fromBorderSide(
          BorderSide(width: 1, color: AppColors.secondary)),
      this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.xs)),
      this.backgroundColor = AppColors.white,
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
              color: backgroundColor,
              borderRadius: borderRadius,
              border: border),
          child: child,
        ),
      ),
    );
  }
}
