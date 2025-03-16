import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/components/notifier/notifybox.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/notification/notification.controllrt.dart';
import 'package:rimpa/modules/models/notification.model.dart';

class NotifyView extends StatefulWidget {
  const NotifyView({super.key});

  @override
  State<NotifyView> createState() => _NotifyViewState();
}

class _NotifyViewState extends State<NotifyView> {
  final NotificationController controller = Get.put(NotificationController()); // ผูก Controller

  @override
  void initState() {
    super.initState();
    controller.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.background_main,
          centerTitle: true,
          title: Text(
            'การแจ้งเตือน',
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
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchNotifications();
          },
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.notifications.isEmpty) {
              return Center(child: Text('ไม่มีการแจ้งเตือน'));
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: showNoti(controller.notifications),
              // child: Text("${controller.notifications}"),
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.fetchNotifications(); // ✅ ดึงข้อมูลใหม่เมื่อลูกค้ากดปุ่ม
          },
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget showNoti(List<NotificationItem> noti) {
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
              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.transparent), borderRadius: BorderRadius.circular(AppRadius.rounded), color: AppColors.accent1),
              child: const Center(
                child: AppImageComponent(imageType: AppImageType.assets, imageAddress: 'assets/icon/noti/nullnoti.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'ยังไม่มีการแจ้งเตือน',
                style: TextStyle(fontSize: AppTextSize.xl, color: AppTextColors.primary),
              ),
            )
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(
            noti.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: noti[index].read
                      ? null
                      : () {
                          controller.readNoti(noti[index].id);
                        },
                  child: NotifierBoxComponent(
                    icons: Icons.notifications_none,
                    topics: noti[index].title,
                    content: noti[index].message,
                    createdAt: noti[index].createdAt,
                    read: noti[index].read,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
