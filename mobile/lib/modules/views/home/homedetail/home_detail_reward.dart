import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:rimpa/core/services/api_urls.dart';

import '../../../controllers/profile/profile_controller.dart';
import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../../components/carousel/app-carousel.component.dart';
import '../../../controllers/reward/list_reward_controller.dart';
import '../../../models/listreward.model.dart'; // Add this import

class HomeDetailReward extends StatelessWidget {
  final ApiUrls apiUrls = Get.find();
  final ListReward reward;
  final RewardController controller = Get.find();
  final ProfileController profileController =
      Get.put(ProfileController()); // ProfileController
  final rewardController = Get.find<RewardController>();
  HomeDetailReward({super.key, required this.reward}); // เอา const ออก

  @override
  Widget build(BuildContext context) {
    // ย้าย rewardcost มาไว้ใน build() แทน

    String? idProfile = profileController.profileData['user_id']?.toString();
    var rewardcost = controller.rewardDetail.value;
    rewardcost["cost"] = reward.cost; // เพิ่มค่า cost ลงใน rewardcost
    // ดึงข้อมูลรางวัล
    String title = reward.rewardName;
    String description = reward.description;
    String startDate = _formatDate(reward.startDate);
    String endDate = _formatDate(reward.endDate);
    String imageUrl = '${AppApi.urlApi}${reward.img.replaceAll("\\", "/")}';
    print(rewardcost);
    print(idProfile);
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                          ratio: 4 / 3,
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
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
                                      border: Border.all(
                                          width: 1, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.rounded),
                                      color: Colors.transparent),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: AppTextSize.xl,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.xs),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.rounded),
                                      color: Colors.transparent),
                                  child: const Icon(
                                    Icons.favorite_border,
                                    size: AppTextSize.xl,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                        border: Border.all(width: 0, color: Colors.transparent),
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
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.xs),
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
                                                      color:
                                                          AppTextColors.dark)),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
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
                                                      gradient: AppGradiant
                                                          .gradientY_1,
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
                                                      return AppGradiant
                                                          .gradientY_1
                                                          .createShader(bounds);
                                                    },
                                                    child: Text(
                                                      reward
                                                          .cost, // Use reward cost
                                                      style: const TextStyle(
                                                          fontSize:
                                                              AppTextSize.md,
                                                          color: AppTextColors
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
                                                  color: AppTextColors.dark)),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                    AppSpacing.xs),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppRadius.rounded),
                                                    color: Colors.transparent),
                                                child: const Icon(
                                                  Icons.calendar_month_outlined,
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
                                                    fontSize: AppTextSize.xs,
                                                    color: AppTextColors.black),
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
                                  padding: const EdgeInsets.all(AppSpacing.xs),
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
                      top: AppSpacing.md,
                      left: AppSpacing.md,
                      right: AppRadius.md,
                      bottom: AppSpacing.lg),
                  child: GestureDetector(
                    onTap: () {
                      if (idProfile != null && reward.cost != null) {
                        Decimal cost =
                            Decimal.tryParse(reward.cost) ?? Decimal.zero;
                        print(
                            "Redeeming reward with idProfile: $idProfile, reward.id: ${reward.id}, cost: $cost");
                        rewardController.redeemReward(
                            idProfile, reward.id.toString(), cost);
                      } else {
                        print("Invalid idProfile or cost");
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppRadius.xs),
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
    );
  }

  String _formatDate(DateTime date) {
    DateTime dateTime = date;
    var thaiDateFormat = DateFormat('d MMM', 'th_TH');
    String formattedDate = thaiDateFormat.format(dateTime);
    String thaiYear =
        (dateTime.year + 543).toString(); // Convert to Buddhist year
    return '$formattedDate $thaiYear';
  }
}
