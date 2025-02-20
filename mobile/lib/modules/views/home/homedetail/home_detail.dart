import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';

class HomeDetailPage extends StatelessWidget {
  const HomeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      const AppImageComponent(
                          aspectRatio: 4 / 3,
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          imageType: AppImageType.network,
                          imageAddress:
                              'https://cdn.prod.website-files.com/61605770a2776f05aa1e318c/66038cbd59912e971580fb95_Cat%20Care%20Routine_%20Tips%20for%20a%20Healthy%2C%20Happy%2C%20%26%20Fabulous%20Cat.webp'),
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
                              horizontal: AppSpacing.md),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lorem Ipsum",
                                    style: TextStyle(
                                        fontSize: AppTextSize.xxl,
                                        color: AppTextColors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        size: AppTextSize.sm,
                                        color: AppColors.accent,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        '2 ก.พ. 2568 - 3 ก.พ. 2568',
                                        style: TextStyle(
                                            fontSize: AppTextSize.xs,
                                            color: AppTextColors.secondary),
                                      ),
                                    ],
                                  ),
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
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.rounded),
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
                        Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.md),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'รายละเอียดกิจกรรม ',
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
                    padding: const EdgeInsets.symmetric(vertical: AppRadius.xs),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.rounded),
                        gradient: AppGradiant.gradientX_1),
                    child: const Center(
                        child: Text(
                      'แลกรับสิทธิ์',
                      style: TextStyle(
                          fontSize: AppTextSize.lg, color: AppTextColors.white),
                    )),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
