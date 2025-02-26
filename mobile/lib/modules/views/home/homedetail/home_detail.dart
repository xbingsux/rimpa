import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // สำหรับการจัดการวันที่
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/controllers/events/list_event_controller.dart';
import 'package:url_launcher/url_launcher.dart'; // เพิ่ม import นี้

class HomeDetailPage extends StatelessWidget {
  final EventController controller = Get.find();
  final int bannerId = Get.arguments; // รับค่า arguments
  ApiUrls apiUrls = Get.find();

  @override
  Widget build(BuildContext context) {
    // Move data fetching inside builder or initState if using StatefulWidget
    if (controller.eventdetail.value.isEmpty) {
      controller.fetcheventdetail(bannerId);
    }

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
                  } else if (controller.errorMessage.value.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  } else if (controller.eventdetail.value.isEmpty) {
                    return const Center(child: Text("ไม่พบข้อมูลกิจกรรม"));
                  }

                  var event = controller.eventdetail.value;

                  // ดึง path ของภาพจาก SubEvent และ img
                  var imagePath =
                      event["SubEvent"] != null && event["SubEvent"].isNotEmpty
                          ? event["SubEvent"][0]["img"][0]["path"]
                              .replaceAll('\\', '/')
                          : '';

                  return AppImageComponent(
                    aspectRatio: 4 / 3,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    imageType: AppImageType.network,
                    imageAddress: imagePath.isNotEmpty
                        ? '${apiUrls.imgUrl.value}$imagePath'
                        : '', // ถ้าไม่มี path จะให้เป็นค่าว่าง
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
                // พื้นที่ด้านล่าง
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  child: AspectRatio(
                    aspectRatio: 100 / 5,
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
            // Content below banner
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
                              var event = controller.eventdetail.value;
                              return Text(
                                event["title"] ?? "ไม่มีหัวข้อ",
                                style: TextStyle(
                                  fontSize: AppTextSize.xxl,
                                  color: AppTextColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                            const SizedBox(height: AppSpacing.xs),
                            Obx(() {
                              var events = controller.eventdetail.value;
                              if (events["startDate"] != null &&
                                  events["endDate"] != null) {
                                var startDate =
                                    DateTime.parse(events["startDate"]);
                                var endDate = DateTime.parse(events["endDate"]);
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
                              } else {
                                return const SizedBox();
                              }
                            }),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            var event = controller.eventdetail.value;
                            var mapUrl = event["SubEvent"] != null &&
                                    event["SubEvent"].isNotEmpty
                                ? event["SubEvent"][0]["map"]
                                : null;

                            if (mapUrl != null && mapUrl.isNotEmpty) {
                              final Uri mapUri = Uri.parse(mapUrl);

                              if (await canLaunchUrl(mapUri)) {
                                await launchUrl(mapUri); // เปิดลิงค์แผนที่
                              } else {
                                // กรณีไม่สามารถเปิด URL ได้
                                throw 'ไม่สามารถเปิด URL แผนที่ได้: $mapUrl';
                              }
                            }
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
                      var event = controller.eventdetail.value;
                      return Text(
                        event["description"] ?? "ไม่มีรายละเอียดแบนเนอร์",
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
