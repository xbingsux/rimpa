import 'package:flutter/material.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/widgets/card/expansion_card.dart';
import 'package:rimpa/widgets/card/expantion_type.dart';

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ช่วยเหลือ",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: AppTextSize.lg,
                fontWeight: FontWeight.w600,
              ),
        ),
        iconTheme: const IconThemeData(color: AppTextColors.secondary),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: AppImageComponent(
              imageType: AppImageType.assets, // ระบุประเภทเป็น Network
              imageAddress: "assets/images/faq.png", // URL ของภาพโปรไฟล์
              aspectRatio: 358 / 160, // อัตราส่วนภาพ (วงกลม)
              // borderRadius: BorderRadius.all(Radius.circular(50)), // รูปทรงวงกลม
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "FAQ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: AppTextSize.lg,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const ExpansionCard(faqData: Faq.account),
                const ExpansionCard(faqData: Faq.point),
                const ExpansionCard(faqData: Faq.reward),
                const ExpansionCard(faqData: Faq.general),
                const ExpansionCard(faqData: Faq.policy),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
