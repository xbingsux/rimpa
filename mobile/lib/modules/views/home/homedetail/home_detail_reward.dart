import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/core/services/date_format.dart';
import 'package:rimpa/modules/controllers/getusercontroller/auth_service.dart';
import 'package:rimpa/modules/views/redeem/redeem_qr_code.dart';
import 'package:rimpa/widgets/button/back_button.dart';
import 'package:rimpa/widgets/button/botton.dart';

import '../../../controllers/profile/profile_controller.dart';
import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../../components/carousel/app-carousel.component.dart';
import '../../../controllers/reward/list_reward_controller.dart';
import '../../../models/listreward.model.dart'; // Add this import

class HomeDetailReward extends StatefulWidget {
  final ListReward reward;
  const HomeDetailReward({super.key, required this.reward});

  @override
  State<HomeDetailReward> createState() => _HomeDetailRewardState();
}

class _HomeDetailRewardState extends State<HomeDetailReward> {
  final ApiUrls apiUrls = Get.find();

  final RewardController controller = Get.find();
  final ProfileController profileController =
      Get.put(ProfileController()); // ProfileController
  final rewardController = Get.find<RewardController>();
  final AuthService authService = Get.find<AuthService>();

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarIconBrightness: Brightness.dark, // เปลี่ยนเป็นสีดำ
    // ));
  }

  @override
  Widget build(BuildContext context) {
    // ย้าย rewardcost มาไว้ใน build() แทน
    authService.checkLoginStatusWithOutForceLogin();
    String? idProfile = profileController.profileData['user_id']?.toString();
    // ignore: invalid_use_of_protected_member
    var rewardcost = controller.rewardDetail.value;
    rewardcost["cost"] = widget.reward.cost; // เพิ่มค่า cost ลงใน rewardcost
    // ดึงข้อมูลรางวัล
    String title = widget.reward.rewardName;
    String description = widget.reward.description;
    String startDate = thDateFormat(widget.reward.startDate);
    String endDate = thDateFormat(widget.reward.endDate);
    String imageUrl =
        '${AppApi.urlApi}${widget.reward.img.replaceAll("\\", "/")}';
    final pointsController = Get.put(PointsController());
    pointsController.fetchpoint();

    return Scaffold(
       appBar:AppBar(
              toolbarHeight: 0,
              // backgroundColor: Colors.amber,
              elevation: 0,
              forceMaterialTransparency: true,
            ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          AppCarousel(
                            imageSrc: AppImageType.network,
                            images: [imageUrl], // Use reward image
                            ratio: 1,
                            borderRadius:
                                BorderRadius.all(Radius.circular(0)),
                          ),
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
                                  border: Border.all(
                                      width: 0, color: Colors.transparent),
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
                          border:
                              Border.all(width: 0, color: Colors.transparent),
                          color: AppColors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.md),
                              child: Text(
                                title, // Use reward name
                                style: const TextStyle(
                                    fontSize: AppTextSize.xxl,
                                    color: AppTextColors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md),
                              child: AspectRatio(
                                aspectRatio: 345 / 80,
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.xs),
                                      color: AppColors.accent1),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
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
                                                        fontSize:
                                                            AppTextSize.xs,
                                                        color: AppTextColors
                                                            .dark)),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(
                                                              AppSpacing.xs),
                                                      decoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                AppRadius
                                                                    .rounded),
                                                        gradient: AppGradiant
                                                            .gradientY_1,
                                                      ),
                                                      child: const Icon(
                                                        Icons.star,
                                                        size: AppTextSize.sm,
                                                        color:
                                                            AppColors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    ShaderMask(
                                                      shaderCallback:
                                                          (bounds) {
                                                        return AppGradiant
                                                            .gradientY_1
                                                            .createShader(
                                                                bounds);
                                                      },
                                                      child: Text(
                                                        widget.reward
                                                            .cost, // Use reward cost
                                                        style: const TextStyle(
                                                            fontSize:
                                                                AppTextSize
                                                                    .md,
                                                            color:
                                                                AppTextColors
                                                                    .white),
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                                                color: AppColors.accent
                                                    .withOpacity(0.25))),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                                'ระยะเวลาในการแลกรับสิทธิ์',
                                                style: TextStyle(
                                                    fontSize: AppTextSize.xs,
                                                    color:
                                                        AppTextColors.dark)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          AppSpacing.xs),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppRadius
                                                                  .rounded),
                                                      color:
                                                          Colors.transparent),
                                                  child: const Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    size: AppTextSize.sm,
                                                    color: AppColors.accent,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '$startDate - $endDate', // Use reward dates
                                                  style: const TextStyle(
                                                      fontSize:
                                                          AppTextSize.xs,
                                                      color: AppTextColors
                                                          .black),
                                                )
                                              ],
                                            )
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
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.md),
                              child: Column(
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
                                    padding:
                                        const EdgeInsets.all(AppSpacing.xs),
                                    child: Text(
                                      description, // Use reward description
                                      style: const TextStyle(
                                        fontSize: AppTextSize.sm,
                                        color: AppTextColors.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                        top: AppSpacing.xl,
                        left: AppSpacing.md,
                        right: AppRadius.md,
                        bottom: AppSpacing.xl),
                    child: GestureDetector(
                      onTap: authService.isLoggedIn.value &&
                              (int.parse(
                                      pointsController.pointsData["points"] ??
                                          '0') >=
                                  int.parse(widget.reward.cost))
                          ? () {
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // ป้องกันกดข้างนอกเพื่อปิด
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.white,
                                    title: Center(
                                      child: Text(
                                        "ยืนยันรับสิทธิ์",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontSize: 20,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "แนะนำให้กดรับสิทธิ์เมื่ออยู่หน้าจุดรับสิทธิ์ เพื่อป้องกันไม่ให้เสียสิทธิ์ เนื่องจากรหัสมีอายุจำกัด",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 14,
                                                  color:
                                                      AppTextColors.secondary,
                                                  fontWeight:
                                                      FontWeight.w500),
                                        ),
                                        Gap(16),
                                        Text(
                                          "รหัสจะหมดอายุภายใน 30 นาที",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.danger,
                                                  fontWeight:
                                                      FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(children: [
                                        Expanded(
                                          child: RimpaButton(
                                            text: 'ยกเลิก',
                                            radius: 32,
                                            disble: false,
                                            onTap: () => Get.back(),
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // เว้นระยะห่างระหว่างปุ่ม
                                        // ปุ่มยืนยันลบ
                                        Expanded(
                                          child: GradiantButton(
                                            text: 'ยืนยัน',
                                            radius: 32,
                                            onTap: () {
                                              Get.back();
                                              Get.to(
                                                  () => ReddemQRcode(
                                                      rewardID:
                                                          widget.reward.id),
                                                  preventDuplicates: true);
                                            },
                                          ),
                                        ),
                                      ])
                                    ],
                                  );
                                },
                              );
                            }
                          : () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppRadius.xs),
                        decoration: authService.isLoggedIn.value &&
                                (int.parse(pointsController
                                            .pointsData["points"] ??
                                        '0') >=
                                    int.parse(widget.reward.cost))
                            ? (BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.rounded),
                                gradient: AppGradiant.gradientX_1))
                            : BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.rounded),
                                color: AppTextColors.secondary,
                              ),
                        child: Center(
                            child: Text(
                          (int.parse(pointsController.pointsData["points"] ??
                                      '0') >=
                                  int.parse(widget.reward.cost))
                              ? 'แลกรับสิทธิ์'
                              : 'คะแนนไม่เพียงพอ',
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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyBackButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
