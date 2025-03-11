import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/components/notifier/notifybox.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/notify/notify.controller.dart';

class NotifyView extends StatelessWidget {
  const NotifyView({super.key});

  @override
  Widget build(BuildContext context) {
    final NotifyController notifyController = Get.put(NotifyController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.background_main,
          centerTitle: true,
          title: const Text('การแจ้งเตือน', style: TextStyle(fontSize: AppTextSize.xl, color: AppTextColors.accent, fontWeight: FontWeight.bold)),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: const Center(
                child: Icon(Icons.arrow_back, color: AppTextColors.secondary, size: AppTextSize.xxl,),
              ),
            ),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.075,
        ),
        body: Obx(() => Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: showNoti(notifyController.notifications),
        ),)
      )
    );
  }

  Widget showNoti(List noti) {
    if (noti.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(AppRadius.rounded),
                color: AppColors.accent1
              ),
              child: const Center(
                child: AppImageComponent(imageType: AppImageType.assets, imageAddress: 'assets/icon/noti/nullnoti.png'),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text('ยังไม่มีการแจ้งเตือน', style: TextStyle(fontSize: AppTextSize.xl, color: AppTextColors.primary),),
            )
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(noti.length, (index) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: NotifierBoxComponent(icons: Icons.notifications_none, topics: 'test', content: 'hi, this is test noti', footnote: '2020-02-14'),
            );
          },),
        ),
      );
    }
  }
}