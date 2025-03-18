import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/widgets/card/expantion_type.dart';

class ExpansionCard extends StatelessWidget {
  final Faq faqData;
  const ExpansionCard({super.key, required this.faqData});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          iconColor: AppColors.gray,
          collapsedIconColor: AppColors.gray,
          initiallyExpanded: false,
          // trailing: const SizedBox.shrink(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 8),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            faqData.title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: AppTextSize.lg,
                  fontWeight: FontWeight.w600,
                ),
          ),
          children: faqData.items
              .map((item) => SizedBox(
                    width: double.infinity,
                    child: Text(
                      item,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: AppTextSize.md,
                            fontWeight: FontWeight.w500,
                            color: AppTextColors.secondary,
                          ),
                    ),
                  )) // ใช้ items จาก Enum Extension
              .toList()),
    );
  }
}
