import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/controllers/profile/profile_controller.dart';
import 'package:rimpa/modules/controllers/reward/list_reward_controller.dart';
import 'package:intl/intl.dart'; // สำหรับการจัดการวันที่
import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../../widgets/popupdialog/popupeventpoint_dialog.dart';
import 'package:decimal/decimal.dart';

class RewardDetail extends StatelessWidget {
  final int bannerId;
  RxString errorMessage =
      ''.obs; // ใช้ RxString เพื่อให้สามารถอัพเดตค่าผ่าน GetX
  final RewardController controller = Get.find();
  final rewardController = Get.find<RewardController>();
  final profileController =
      Get.put(ProfileController()); // เพิ่ม ProfileController
  final pointsController =
      Get.put(PointsController()); // เพิ่ม ProfileController
  var isLoading = false.obs;
  var isButtonDisabled = false.obs; // กำหนดปุ่มให้ไม่สามารถกดได้
  ApiUrls apiUrls = Get.find();
  RewardDetail({required this.bannerId});

  @override
  Widget build(BuildContext context) {
    if (controller.rewardDetail.value.isEmpty) {
      controller.fetchRewardDetail(bannerId);
    }
    String? idProfile = profileController.profileData['id']
        ?.toString(); // ดึง id ของโปรไฟล์จากข้อมูลที่ได้
    // พิมพ์ค่า idProfile ออกมาใน console
    var points = Decimal.tryParse(
            pointsController.pointsData['points']?.toString() ?? '0') ??
        Decimal.zero;

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
                  } else if (controller.rewardDetail.isEmpty) {
                    return const Center(child: Text("ไม่พบข้อมูลแบนเนอร์"));
                  }

                  var banner = controller.rewardDetail
                      .value; // ใช้ controller.rewardDetail.value แทน banner
                  var cost = Decimal.tryParse('${banner["cost"] ?? 0}') ??
                      Decimal.zero;

                  // ปริ้นค่าของ points และ cost
                  return AppImageComponent(
                    aspectRatio: 4 / 3, // ใช้ ratio เดียวกัน
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    imageType: AppImageType.network,
                    imageAddress:
                        '${controller.apiUrlsController.imgUrl.value}${banner["img"]}',
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
                border: Border.all(width: 0, color: Colors.transparent),
                color: AppColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ใช้ข้อมูลจาก reward_name ในฐานข้อมูล
                  Obx(() {
                    var banner = controller.rewardDetail.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.md),
                      child: Text(
                        banner["reward_name"] ??
                            "ไม่มีข้อมูล", // กรณีไม่มีข้อมูลใน reward_name
                        style: TextStyle(
                            fontSize: AppTextSize.xxl,
                            color: AppTextColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: AspectRatio(
                      aspectRatio: 345 / 80,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                            color: AppColors.accent1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('ใช้คะแนนสะสม',
                                          style: TextStyle(
                                              fontSize: AppTextSize.xs,
                                              color: AppTextColors.dark)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Obx(() {
                                        var banner =
                                            controller.rewardDetail.value;
                                        return Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(
                                                  AppSpacing.xs),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppRadius.rounded),
                                                gradient:
                                                    AppGradiant.gradientY_1,
                                              ),
                                              child: const Icon(
                                                Icons.star,
                                                size: AppTextSize.sm,
                                                color: AppColors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            ShaderMask(
                                              shaderCallback: (bounds) {
                                                return AppGradiant.gradientY_1
                                                    .createShader(bounds);
                                              },
                                              child: Text(
                                                '${banner["cost"] ?? 0}', // ใช้ข้อมูลจาก cost
                                                style: TextStyle(
                                                    fontSize: AppTextSize.md,
                                                    color: AppTextColors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                  child: Container(
                                      width: 2,
                                      color:
                                          AppColors.accent.withOpacity(0.25))),
                            ),
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('ระยะเวลาในการแลกรับสิทธิ์',
                                      style: TextStyle(
                                          fontSize: AppTextSize.xs,
                                          color: AppTextColors.dark)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // ด้านใน `Obx` ที่คุณต้องการใช้
                                  Obx(() {
                                    var banner = controller.rewardDetail.value;

                                    // แปลงวันที่จาก String ในฐานข้อมูลเป็นวันที่ในภาษาไทย
                                    String startDate =
                                        banner["startDate"] ?? "ไม่ระบุ";
                                    String endDate =
                                        banner["endDate"] ?? "ไม่ระบุ";

                                    // ตรวจสอบว่า startDate และ endDate เป็นค่าว่างหรือไม่
                                    String formattedStartDate = startDate !=
                                            "ไม่ระบุ"
                                        ? DateFormat('d MMM yyyy', 'th_TH')
                                            .format(DateTime.parse(startDate))
                                        : "ไม่ระบุ";
                                    String formattedEndDate =
                                        endDate != "ไม่ระบุ"
                                            ? DateFormat('d MMM yyyy', 'th_TH')
                                                .format(DateTime.parse(endDate))
                                            : "ไม่ระบุ";

                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                              AppSpacing.xs),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                AppRadius.rounded),
                                            color: Colors.transparent,
                                          ),
                                          child: const Icon(
                                            Icons.calendar_month_outlined,
                                            size: AppTextSize.sm,
                                            color: AppColors.accent,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '$formattedStartDate - $formattedEndDate',
                                          style: TextStyle(
                                            fontSize: AppTextSize.xs,
                                            color: AppTextColors.black,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.md),
                    child: Obx(() {
                      var banner = controller.rewardDetail.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'เงื่อนไขการรับสิทธิ์',
                            style: TextStyle(
                                fontSize: AppTextSize.sm,
                                color: AppTextColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.all(AppSpacing.xs),
                            child: Text(
                              banner["description"] ??
                                  "ไม่มีข้อมูล", // ใช้ข้อมูลจาก description
                              style: TextStyle(
                                fontSize: AppTextSize.sm,
                                color: AppTextColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Column(
                    children: [
                      // แสดงข้อความข้อผิดพลาด (ถ้ามี)
                      if (errorMessage.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm),
                          child: Text(
                            errorMessage.value,
                            style: TextStyle(
                                color: Colors.red, fontSize: AppTextSize.md),
                          ),
                        ),
                      // ส่วนของปุ่มแลกรางวัล
                      Padding(
                          padding: const EdgeInsets.only(
                            top: AppSpacing.md,
                            left: AppSpacing.md,
                            right: AppRadius.md,
                            bottom: AppSpacing.lg,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (isLoading.value) return; // ป้องกันการกดซ้ำ
                              bool isRedeemed = rewardController
                                      .rewardDetail.value['isRedeemed'] ??
                                  false;

                              if (!isRedeemed) {
                                String? idProfile = profileController
                                    .profileData.value['id']
                                    ?.toString();
                                if (idProfile != null) {
                                  String idReward = controller
                                          .rewardDetail.value["id"]
                                          ?.toString() ??
                                      "defaultRewardId";

                                  var points = Decimal.tryParse(
                                          pointsController
                                                  .pointsData['points']
                                                  ?.toString() ??
                                              '0') ??
                                      Decimal.zero;
                                  var cost = Decimal.tryParse(
                                          '${controller.rewardDetail["cost"] ?? 0}') ??
                                      Decimal.zero;

                                  isLoading.value = true; // เริ่มโหลด
                                  rewardController
                                      .redeemReward(
                                          idProfile, idReward, points, cost)
                                      .then((_) {
                                    isLoading.value =
                                        false; // หยุดโหลดเมื่อเสร็จ
                                  }).catchError((error) {
                                    isLoading.value = false;
                                    errorMessage.value =
                                        'เกิดข้อผิดพลาดในการแลกรางวัล';
                                  });
                                } else {
                                  print("ไม่สามารถดึง ID โปรไฟล์ได้");
                                }
                              }
                            },
                            child: Obx(() {
                              bool isRedeemed = rewardController
                                      .rewardDetail.value['isRedeemed'] ??
                                  false;
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppRadius.xs),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.rounded),
                                  gradient: isRedeemed
                                      ? LinearGradient(
                                          colors: [Colors.grey, Colors.grey])
                                      : AppGradiant.gradientX_1,
                                ),
                                child: Center(
                                  child: isRedeemed
                                      ? const Text(
                                          'คุณเคยแลกรางวัลนี้ไปแล้ว',
                                          style: TextStyle(
                                              fontSize: AppTextSize.lg,
                                              color: AppTextColors.white),
                                        )
                                      : const Text(
                                          'แลกรางวัล',
                                          style: TextStyle(
                                              fontSize: AppTextSize.lg,
                                              color: AppTextColors.white),
                                        ),
                                ),
                              );
                            }),
                          )),
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
