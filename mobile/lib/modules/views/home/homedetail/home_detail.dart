import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:rimpa/modules/controllers/events/list_event_controller.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../../components/carousel/app-carousel.component.dart';
import '../../../models/listevent.model.dart';
import '../../../../widgets/popupdialog/popupeventpoint_dialog.dart';

class HomeDetailPage extends StatelessWidget {
  final ListEvent event;
  const HomeDetailPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    // Extract event details
    Get.put(EventController()); // เพิ่มการสร้าง EventController
    String id_event = event.subEvents[0].id
        .toString(); 
    String title = event.title;
    String description = event.description;
    String startDate = _formatDate(event.startDate); // Update this line
    String endDate = _formatDate(event.endDate); // Update this line
    String imageUrl =
        '${AppApi.urlApi}${event.subEvents[0].imagePath.replaceAll("\\", "/")}';
    String mapUrl = event.subEvents[0].map;
    final evencontroller = Get.find<EventController>();
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
                                GestureDetector(
                                  onTap: () {
                                    if (mapUrl.isNotEmpty) {
                                      _launchURL(mapUrl); // Update this line
                                    }
                                  },
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
                                const Text(
                                  'รายละเอียดกิจกรรม ',
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
  // รับค่า id_event จาก event.subEvents[0].id
  int subEventId = event.subEvents[0].id;

  // เรียกใช้งานฟังก์ชัน checkIn พร้อมส่ง sub_event_id และ context
  evencontroller.checkIn(subEventId, context);
},

                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppRadius.xs),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppRadius.rounded),
                          color:
                              const Color(0xFFEBF5FD)), // Corrected color definition
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                gradient:
                                    AppGradiant.gradientX_1, // Applied gradient
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.star, color: Colors.white),
                            ),
                            const SizedBox(width: 8), // Added missing comma
                            const Text(
                              '100 คะแนน',
                              style: TextStyle(
                                  fontSize: AppTextSize.lg,
                                  color: AppTextColors.accent2),
                            ),
                            Opacity(
                              // space
                              opacity: 0,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  gradient: AppGradiant
                                      .gradientX_1, // Applied gradient
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.star, color: Colors.white),
                              ),
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

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url); // Parse the URL
    Uri googleMapsUri =
        Uri.parse('google.navigation:q=$url'); // Google Maps URL scheme

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    var thaiDateFormat = DateFormat('d MMM', 'th_TH');
    String formattedDate = thaiDateFormat.format(dateTime);
    String thaiYear =
        (dateTime.year + 543).toString(); // Convert to Buddhist year
    return '$formattedDate $thaiYear';
  }
}
