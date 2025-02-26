import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import

import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../../components/carousel/app-carousel.component.dart';
import '../../../models/listevent.model.dart';
import '../../../../widgets/popupdialog/popupeventpoint_dialog.dart';

class HomeDetailPage extends StatelessWidget {
  final ListEvent event;

  const HomeDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Extract event details
    String title = event.title;
    String description = event.description;
    String startDate = _formatDate(event.startDate); // Update this line
    String endDate = _formatDate(event.endDate); // Update this line
    List<String> imageUrls = event.subEvents[0].img
        .map((image) => '${AppApi.urlApi}${image.path.replaceAll("\\", "/")}')
        .toList(); // Update this line
    String mapUrl = event.subEvents[0].map;

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
                          images: imageUrls, // Update this line
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
                                        Text(
                                          '$startDate - $endDate',
                                          style: TextStyle(
                                              fontSize: AppTextSize.xs,
                                              color: AppTextColors.secondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  // onTap: () {
                                  //   if (mapUrl.isNotEmpty) {
                                  //     Get.to(() => WebViewPage(url: mapUrl));
                                  //   }
                                  // },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(AppSpacing.sm),
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
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.3,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.md),
                            child: Column(
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
                                    description,
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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(context: context);
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppRadius.xs),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppRadius.rounded),
                          gradient: AppGradiant.gradientX_1),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient:
                                    AppGradiant.gradientX_1, // Applied gradient
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.star, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '100 คะแนน',
                              style: TextStyle(
                                  fontSize: AppTextSize.lg,
                                  color: AppTextColors.white),
                            ),
                          ],
                        ),
                      ),
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

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    var thaiDateFormat = DateFormat('d MMM', 'th_TH');
    var thaiYearFormat = DateFormat('yyyy', 'th_TH');
    String formattedDate = thaiDateFormat.format(dateTime);
    String thaiYear =
        (dateTime.year + 543).toString(); // Convert to Buddhist year
    return '$formattedDate $thaiYear';
  }
}
