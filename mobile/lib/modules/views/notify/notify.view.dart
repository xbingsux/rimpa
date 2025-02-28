import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/components/notifier/notifybox.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class NotifyView extends StatelessWidget {
  const NotifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.light,
          centerTitle: true,
          title: const Text('การแจ้งเตือน', style: TextStyle(fontSize: AppTextSize.xl, color: AppTextColors.accent)),
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
        ),
        body: showNoti([{'adsf':'sdf'}, {'adsf':'sdf'}, {'adsf':'sdf'}]),
      )
    );
  }

  Widget showNoti(List<Map<String, dynamic>> noti) {
    if (noti.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.circular(AppRadius.rounded),
              color: AppColors.accent1
            ),
            child: const Center(
              child: AppImageComponent(imageType: AppImageType.assets, imageAddress: 'assets/icon/noti/nullnoti.png'),
            ),
          )
        ],
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(noti.length, (index) {
            return const NotifierBoxComponent(icons: Icons.notifications_none, topics: 'test', content: 'hi, this is test noti', footnote: '2020-02-14');
          },),
        ),
      );
    }
  }
}