import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotifierBoxComponent extends StatelessWidget {
  final IconData icons;
  final String topics;
  final String content;
  final DateTime createdAt;
  final bool read;
  const NotifierBoxComponent({super.key, required this.icons, required this.topics, required this.content, required this.createdAt, required this.read});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent1,
              borderRadius: BorderRadius.circular(AppRadius.rounded),
            ),
            child: Container(
              width: 20,
              height: 20,
              child: Icon(
                icons,
                size: AppTextSize.xxl,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(width: 1, color: Colors.transparent),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(AppRadius.sm),
                        bottomRight: Radius.circular(
                          AppRadius.sm,
                        ),
                        bottomLeft: Radius.circular(AppRadius.sm)),
                    boxShadow: [
                      AppShadow.custom(
                        color: AppColors.secondary,
                        blurRadius: 3,
                        spreadRadius: 1,
                      )
                    ]),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: AppTextSize.sm,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: AppTextSize.xs,
                                fontWeight: FontWeight.w400,
                                color: AppTextColors.secondary,
                              ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "${timeago.format(createdAt, locale: 'th_short')}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppTextColors.secondary,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
