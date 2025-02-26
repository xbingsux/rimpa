import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // สำหรับการจัดการวันที่
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/events/list_banner_controller_.dart';

class BannersDetailPage extends StatelessWidget {
  final int bannerId;
  final BannerEventController controller = Get.find();

  BannersDetailPage({required this.bannerId});

  @override
  Widget build(BuildContext context) {
  controller.fetchBannerDetail(bannerId);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                // การแสดงภาพแบนเนอร์
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.errorMessage.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  } else if (controller.bannerDetail.isEmpty) {
                    return const Center(child: Text("ไม่พบข้อมูลแบนเนอร์"));
                  }

                  var banner = controller.bannerDetail.value;
                  return AppImageComponent(
                    aspectRatio: 4 / 3, // ใช้ ratio เดียวกัน
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    imageType: AppImageType.network,
                    imageAddress:
                        '${controller.apiUrlsController.imgUrl.value}${banner["path"]}',
                  );
                }),

                // ปุ่มย้อนกลับ
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: AppColors.white),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.rounded),
                              color: Colors.transparent),
                          child: const Icon(
                            Icons.arrow_back,
                            size: AppTextSize.xl,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // พื้นที่ด้านล่าง (เหมือนเดิม)
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  child: AspectRatio(
                    aspectRatio: 100 / 5, // ใช้ ratio เดียวกัน
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.xl),
                          topRight: Radius.circular(AppRadius.xl),
                        ),
                        border: Border.all(width: 0, color: Colors.transparent),
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              var banner = controller.bannerDetail.value;
                              return Text(
                                banner["title"] ?? "ไม่มีชื่อแบนเนอร์",
                                style: TextStyle(
                                  fontSize: AppTextSize.xxl,
                                  color: AppTextColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                            const SizedBox(height: AppSpacing.xs),
                            Obx(() {
                              var banner = controller.bannerDetail.value;
                              // แปลงวันที่จาก API เป็นรูปแบบไทย
                              var startDate = DateTime.parse(banner["startDate"]);
                              var endDate = DateTime.parse(banner["endDate"]);
                              var formatter = DateFormat('d MMM yyyy');
                              return Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: AppTextSize.sm,
                                    color: AppColors.accent,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${formatter.format(startDate)} - ${formatter.format(endDate)}',
                                    style: TextStyle(
                                      fontSize: AppTextSize.xs,
                                      color: AppTextColors.secondary,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle map icon tap
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.transparent,
                              ),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.rounded),
                              color: Colors.blue,
                            ),
                            child: const Icon(
                              Icons.location_on_outlined,
                              size: AppTextSize.xxl,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.md),
                    child: Obx(() {
                      var banner = controller.bannerDetail.value;
                      return Text(
                        banner["description"] ?? "ไม่มีรายละเอียดแบนเนอร์",
                        style: const TextStyle(fontSize: AppTextSize.sm),
                      );
                    }),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: AppColors.secondary,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: AppSpacing.md,
                            left: AppSpacing.md,
                            right: AppRadius.md,
                            bottom: AppSpacing.lg),
                        child: GestureDetector(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppRadius.xs),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.rounded),
                                gradient: AppGradiant.gradientX_1),
                            child: const Center(
                                child: Text(
                              'แลกรับสิทธิ์',
                              style: TextStyle(
                                  fontSize: AppTextSize.lg,
                                  color: AppTextColors.white),
                            )),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
