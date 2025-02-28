import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class NotifierBoxComponent extends StatelessWidget {
  final IconData icons;
  final String topics;
  final String content;
  final String footnote;
  const NotifierBoxComponent({super.key, required this.icons, required this.topics, required this.content, required this.footnote});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.accent1,
                border: Border.all(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(AppRadius.rounded)
              ),
              child: Icon(
                icons,
                size: AppTextSize.xxl,
                color: AppTextColors.accent,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:  AppSpacing.sm),
              child: AspectRatio(
                aspectRatio: 3.23 / 1,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(width: 1, color: Colors.transparent),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(AppRadius.sm),
                      bottomRight: Radius.circular(AppRadius.sm),
                      bottomLeft: Radius.circular(AppRadius.sm)
                    ),
                    boxShadow: [AppShadow.custom(color: AppColors.secondary, blurRadius: 3, spreadRadius: 1)]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topics,
                            style: const TextStyle(
                              fontSize: AppTextSize.md,
                              color: AppTextColors.black,
                            ),
                          ),
                          Text(
                            content,
                            style: const TextStyle(
                              fontSize: AppTextSize.sm,
                              color: AppTextColors.secondary
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          footnote,
                          style: const TextStyle(
                            fontSize: AppTextSize.xs,
                            color: AppTextColors.secondary
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}