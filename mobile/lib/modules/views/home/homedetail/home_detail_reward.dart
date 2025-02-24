import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../../components/carousel/app-carousel.component.dart';

class HomeDetailReward extends StatelessWidget {
  const HomeDetailReward({super.key});

  @override
  Widget build(BuildContext context) {
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
                        const AppCarousel(
                          imageSrc: AppImageType.network,
                          images: [
                            'https://cdn.prod.website-files.com/61605770a2776f05aa1e318c/66038cbd59912e971580fb95_Cat%20Care%20Routine_%20Tips%20for%20a%20Healthy%2C%20Happy%2C%20%26%20Fabulous%20Cat.webp',
                            'https://cdn.prod.website-files.com/61605770a2776f05aa1e318c/66038cbd59912e971580fb95_Cat%20Care%20Routine_%20Tips%20for%20a%20Healthy%2C%20Happy%2C%20%26%20Fabulous%20Cat.webp',
                            // Add more image URLs here
                          ],
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
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.md),
                            child: Text(
                              "Lorem Ipsum",
                              style: TextStyle(
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
                                                    child: const Text(
                                                      '500',
                                                      style: TextStyle(
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
                                              const Text(
                                                '2 ก.พ. 2568 - 3 ก.พ. 2568',
                                                style: TextStyle(
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
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'เงื่อนไขการรับสิทธิ์',
                                  style: TextStyle(
                                      fontSize: AppTextSize.sm,
                                      color: AppTextColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(AppSpacing.xs),
                                  child: Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                    style: TextStyle(
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
}
