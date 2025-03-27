import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:rimpa/modules/controllers/events/list_event_controller.dart';
import 'package:rimpa/modules/controllers/getusercontroller/auth_service.dart';
import 'package:rimpa/modules/views/home/home_qr.dart';
import 'package:rimpa/widgets/button/back_button.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import
import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../../components/carousel/app-carousel.component.dart';
import '../../../models/listevent.model.dart';

class HomeDetailPage extends StatelessWidget {
  final ListEvent event;
  const HomeDetailPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    List<String> paths = event.subEvents
        .expand((subEvent) => subEvent.img
            .map((img) => '${AppApi.urlApi}${img.path}'.replaceAll("\\", "/")))
        .toList();
    // Extract event details
    Get.put(EventController()); // เพิ่มการสร้าง EventController
    // String id_event = event.subEvents[0].id.toString();
    String title = event.title;
    String description = event.description;
    String startDate = _formatDate(event.startDate); // Update this line
    String endDate = _formatDate(event.endDate); // Update this line
    String imageUrl =
        '${AppApi.urlApi}${event.subEvents[0].imagePath.replaceAll("\\", "/")}';
    print(imageUrl);
    String mapUrl = event.subEvents[0].map.trim(); // ตัดช่องว่างออก
    // ดึงค่าพอยท์จาก subEvents (ตัวแรกในกรณีนี้)
    // ใช้ RxString สำหรับค่าพอยท์
    RxDouble point =
        event.subEvents[0].point.obs; // ใช้ .obs เพื่อทำให้เป็น reactive
    final evencontroller = Get.find<EventController>();
    final AuthService authService = Get.find<AuthService>();
    authService.checkLoginStatusWithOutForceLogin();
    double mediaHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
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
                    children: [
                      Stack(
                        children: [
                          AppCarousel(
                            imageSrc: AppImageType.network,
                            images: paths,
                            ratio: 1 / 1,
                            indicatorBottomSpace: 30,
                          ),
                        ],
                      ),
                      Transform.translate(
                        offset: Offset(0, -mediaHeight * 0.03),
                        child: Container(
                          width: mediaWidth,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppRadius.lg),
                              topRight: Radius.circular(AppRadius.lg),
                            ),
                            color: AppColors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.lg,
                              horizontal: AppSpacing.lg,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: const TextStyle(
                                                fontSize: AppTextSize.xxl,
                                                color: AppTextColors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                              height: AppSpacing.xs),
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
                                                    color: AppTextColors
                                                        .secondary),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (mapUrl.isNotEmpty)
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                            child: GestureDetector(
                                          onTap: () {
                                            if (mapUrl.isNotEmpty) {
                                              _launchURL(context, mapUrl);
                                            } else {
                                              // แจ้งเตือนว่าหมุดแผนที่ไม่มี
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'ไม่มีลิงก์แผนที่สำหรับอีเว้นต์นี้')),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                                AppSpacing.sm),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 0.5,
                                                color: Colors.transparent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppRadius.rounded),
                                              color: mapUrl.isNotEmpty
                                                  ? Colors.blue
                                                  : Colors
                                                      .grey, // เปลี่ยนสีปุ่มถ้าไม่มีลิงก์
                                            ),
                                            child: const Icon(
                                              Icons.location_on_outlined,
                                              size: AppTextSize.xxl,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                      )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.md),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'รายละเอียดกิจกรรม ',
                                        style: TextStyle(
                                            fontSize: AppTextSize.sm,
                                            color: AppTextColors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            AppSpacing.xs),
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
                      onTap: authService.isLoggedIn.value
                          ? () {
                              // HomeQRPage()
                              Get.to(() => HomeQRPage(),
                                  preventDuplicates: true);
                            }
                          : () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppRadius.xs),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppRadius.rounded),
                          color: authService.isLoggedIn.value
                              ? const Color(0xFFEBF5FD)
                              : AppColors.secondary, // แก้ไขสีให้ถูกต้อง
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: authService.isLoggedIn.value
                                    ? BoxDecoration(
                                        gradient: AppGradiant
                                            .gradientX_1, // ใช้ Gradient
                                        shape: BoxShape.circle,
                                      )
                                    : BoxDecoration(
                                        color: AppTextColors
                                            .secondary, // ใช้ Gradient
                                        shape: BoxShape.circle,
                                      ),
                                child: const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                              ),
                              const SizedBox(
                                  width: 8), // เพิ่ม const เพื่อลด warning
                              Obx(() {
                                return Text(
                                  '${point.value.toInt()} คะแนน', // ค่าพอยท์ที่ถูกดึงจาก RxString
                                  style: TextStyle(
                                    fontSize: AppTextSize.lg,
                                    color: authService.isLoggedIn.value
                                        ? AppTextColors.accent2
                                        : AppTextColors.secondary,
                                  ),
                                );
                              }),
                              Gap(38),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

  void _launchURL(BuildContext context, String url) async {
    if (url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่มีลิงก์แผนที่สำหรับอีเว้นต์นี้')),
      );
      return;
    }

    Uri uri = Uri.parse(url);
    Uri googleMapsUri = Uri.parse('google.navigation:q=$url');

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเปิดลิงก์แผนที่ได้')),
      );
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

  // Widget eventButton () {
  //   final DateTime now = DateTime.now();

  //   if ()
  // }
}
