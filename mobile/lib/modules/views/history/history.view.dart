import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rimpa/components/cards/app-card.component.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/history/history.controller.dart';
import 'package:rimpa/modules/models/history/historypoint.model.dart';

enum HistoryType {
  all,
  earn,
  redeem
}

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController historyController = Get.put(HistoryController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background_main,
          centerTitle: true,
          title: Text(
            'ประวัติคะแนน',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: AppTextSize.xl,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: AppTextColors.secondary,
                  size: AppTextSize.xxl,
                ),
              ),
            ),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.075,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    historyTypeButton(
                      context, 
                      historyController.activeType.value == HistoryType.all,
                      () {
                        historyController.activeType.value = HistoryType.all;
                        historyController.fetchPointHistory();
                      }, 
                      'ทั้งหมด'
                    ),
                    historyTypeButton(
                      context, 
                      historyController.activeType.value == HistoryType.earn,
                      () {
                        historyController.activeType.value = HistoryType.earn;
                        historyController.fetchPointHistory();
                      }, 
                      'รับคะแนน'
                    ),
                    historyTypeButton(
                      context, 
                      historyController.activeType.value == HistoryType.redeem,
                      () {
                        historyController.activeType.value = HistoryType.redeem;
                        historyController.fetchPointHistory();
                      }, 
                      'แลกคะแนน'
                    ),
                  ],
                ),
              )),
            ),
            Obx(() => historyDisplay(context, historyController.historyPointList))
          ],
        ),
      )
    );
  }

  Widget historyTypeButton(BuildContext context, bool isActive, Function onTap, String buttonText) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.background_main,
            border: Border.all(width: 1, color: isActive? AppTextColors.accent : AppTextColors.secondary),
            borderRadius: BorderRadius.circular(AppRadius.md)
          ),
          child: Center(
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: AppTextSize.sm,
                fontWeight: FontWeight.w400,
                color: isActive? AppTextColors.accent : AppTextColors.secondary
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget historyDisplay(BuildContext context, List<HistoryPointModel> historyList) {
    if (historyList.isNotEmpty) {
      return Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: AppRadius.md, right: AppRadius.md, bottom: AppRadius.md),
            child: Column(
              children: List.generate(historyList.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 0.0 : AppSpacing.md),
                  child: AppCardComponent(
                    aspectRatio: 358/80,
                    border: Border.all(width: 1, color: AppColors.secondary),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    boxShadow: BoxShadow(blurRadius: 4, color: AppColors.black.withOpacity(0.25)),
                    incardPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xs),
                              child: Container(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.035),
                                decoration: BoxDecoration(
                                  color: historyList[index].type == 'REDEEM' ? AppColors.softdanger : AppColors.softsuccess,
                                  borderRadius: BorderRadius.circular(AppRadius.rounded)
                                ),
                                child: AppImageComponent(imageType: AppImageType.assets, imageAddress: historyList[index].type == 'REDEEM' ? 'assets/icon/history/redeem.png' : 'assets/icon/history/earn.png', aspectRatio: 1/1,)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      historyList[index].description,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        fontSize: AppTextSize.sm,
                                        fontWeight: FontWeight.w600,
                                        color: AppTextColors.primary
                                      ),
                                    ),
                                    Text(
                                      historyList[index].type == 'REDEEM' ? '- ${historyList[index].points}' : '+ ${historyList[index].points}',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        fontSize: AppTextSize.sm,
                                        fontWeight: FontWeight.w600,
                                        color: historyList[index].type == 'REDEEM' ? AppColors.danger : AppColors.success
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(historyList[index].updatedAt),
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: AppTextSize.xs,
                                    fontWeight: FontWeight.w400,
                                    color: AppTextColors.secondary
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ), 
                  ),
                );
              },),
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: Transform.translate(
            offset: Offset(0, - MediaQuery.of(context).size.height * 0.075),
            child: Text(
              'ไม่มีการดำเนินการ',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: AppTextSize.sm,
                fontWeight: FontWeight.w600,
                color: AppTextColors.secondary
              ),
            ),
          ),
        ),
      );
    }
  }
}