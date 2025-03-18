import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import

import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../../components/carousel/app-carousel.component.dart';
import '../../../models/listbanner.model.dart';

class BannerDetailPage extends StatelessWidget {
  final ListBanner banner;

  const BannerDetailPage({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {

    // Extract banner details
    String title = banner.title;
    String description = banner.description;
    String startDate = _formatDate(banner.startDate); // Updated line
    String endDate = _formatDate(banner.endDate); // Updated line
    String imageUrl = '${AppApi.urlApi}${banner.path.replaceAll("\\", "/")}';

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
                          images: [imageUrl],
                          ratio: 4 / 3,
                          indicatorBottomSpace: 0,
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
                                    Text(
                                      title,
                                      style: const TextStyle(
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
                                        Text(
                                          '$startDate - $endDate',
                                          style: const TextStyle(
                                              fontSize: AppTextSize.xs,
                                              color: AppTextColors.secondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
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
                                  'รายละเอียด',
                                  style: TextStyle(
                                      fontSize: AppTextSize.sm,
                                      color: AppTextColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(AppSpacing.xs),
                                  child: Text(
                                    description,
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
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Updated parameter type
    DateTime dateTime = date; // Updated line
    var thaiDateFormat = DateFormat('d MMM', 'th_TH');
    String formattedDate = thaiDateFormat.format(dateTime);
    String thaiYear =
        (dateTime.year + 543).toString(); // Convert to Buddhist year
    return '$formattedDate $thaiYear';
  }
}
