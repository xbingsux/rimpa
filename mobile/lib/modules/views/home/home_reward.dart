import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/modules/views/home/seeallcards/home_event_allcard.dart';
import 'dart:async';

import '../../../core/services/api_urls.dart';
import '../../../widgets/shimmerloadwidget/shimmer.widget.dart';
import '../../../components/cards/app-card.component.dart';
import '../../../components/imageloader/app-image.component.dart';
import '../../../core/constant/app.constant.dart';
import '../../controllers/profile/profile_controller.dart';
import 'seeallcards/recommended_privileges.dart';
import 'homedetail/home_detail_reward.dart'; // Add this import
import '../../controllers/listreward/listreward.controller.dart'; // Add this import
import '../../controllers/listbanner/listbanner.controller.dart'; // Add this import
import '../../controllers/listevent/listevent.controller.dart'; // Add this import

class HomeRewardPage extends StatefulWidget {
  @override
  _HomeRewardPageState createState() => _HomeRewardPageState();
}

class _HomeRewardPageState extends State<HomeRewardPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  final listRewardController = Get.put(ListRewardController()); // Add this line
  final listBannerController = Get.put(ListBannerController()); // Add this line
  final listEventController = Get.put(ListEventController()); // Add this line

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < listBannerController.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ApiUrls apiUrls = Get.find();
    final profileController =
        Get.put(ProfileController()); // เพิ่ม ProfileController
    final pointsController =
        Get.put(PointsController()); // เพิ่ม ProfileController
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppGradiant.gradientX_1,
              ),
              child: Column(
                children: [
                  // Custom App Bar
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppGradiant.gradientX_1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // รูปโปรไฟล์แทนไอคอน
                            Obx(() {
                              // ดึงข้อมูล URL ของรูปโปรไฟล์จาก Controller
                              String profileImage = profileController
                                      .profileData["profile_img"] ??
                                  '';

                              // สร้าง URL ของภาพจาก path ที่ต้องการ
                              String imageUrl = profileImage.isEmpty
                                  ? 'assets/images/default_profile.jpg'
                                  : '${apiUrls.imgUrl.value}$profileImage'; // กำหนด URL รูปโปรไฟล์

                              return Container(
                                width: 40, // ขนาดเท่ากับไอคอนเดิม
                                height: 40, // ขนาดเท่ากับไอคอนเดิม
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Colors.grey[300], // พื้นหลังเทาเหมือนเดิม
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    width: 40, // ให้รูปอยู่ในขนาด 40x40 px
                                    height: 40,
                                    fit: BoxFit.cover, // ปรับให้เต็มวงกลม
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.person_outline,
                                          color: Colors.grey, size: 24);
                                    },
                                  ),
                                ),
                              );
                            }),

                            SizedBox(width: 8),

                            // ชื่อโปรไฟล์
                            Obx(() {
                              var profileName = profileController
                                      .profileData["profile_name"] ??
                                  "ยังไม่ได้ล็อคอิน";

                              return Text(
                                profileName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 16, // ปรับขนาดฟอนต์เป็น 16
                                    ),
                              );
                            }),
                          ],
                        ),

                        // ไอคอนแจ้งเตือน
                        Icon(Icons.notifications_none, color: Colors.white),
                      ],
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      gradient: AppGradiant.gradientX_1,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor, // รองรับ Light/Dark Mode
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Removed card here
                          SizedBox(height: 40),
                          // Banner slider
                          Obx(() {
                            if (listBannerController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return SizedBox(
                                height: 150,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount:
                                      listBannerController.banners.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    var banner =
                                        listBannerController.banners[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(HomeDetailReward());
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: AppImageComponent(
                                          aspectRatio: 16 / 9,
                                          fit: BoxFit.cover,
                                          imageType: AppImageType.network,
                                          imageAddress:
                                              '${AppApi.urlApi}${banner.path.replaceAll("\\", "/")}', // Use AppApi.urlApi
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                listBannerController.banners.length, (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPage == index ? 12 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? Colors.blue
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 16),
                          // Activities Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "สิทธิพิเศษแนะนำ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(RecommendedPrivilegesPage());
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "ดูทั้งหมด",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      " >",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Obx(() {
                            if (listRewardController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: listRewardController.rewards
                                      .map((reward) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(HomeDetailReward());
                                      },
                                      child: Container(
                                        width: 150,
                                        margin: EdgeInsets.only(right: 8),
                                        child: AppCardComponent(
                                          child: Column(
                                            children: [
                                              AppImageComponent(
                                                imageType: AppImageType.network,
                                                imageAddress:
                                                    '${AppApi.urlApi}${reward.img.replaceAll("\\", "/")}', // Use AppApi.urlApi
                                              ),
                                              SizedBox(height: 8),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Text(
                                                  reward.rewardName,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          }),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "สิ่งที่บันทึก",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(RecommendedPrivilegesPage());
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "ดูทั้งหมด",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      " >",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Obx(() {
                            if (listEventController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      listEventController.events.map((event) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(HomeDetailReward());
                                      },
                                      child: Container(
                                        width: 150,
                                        margin: EdgeInsets.only(right: 8),
                                        child: AppCardComponent(
                                          child: Column(
                                            children: [
                                              AppImageComponent(
                                                imageType: AppImageType.network,
                                                imageAddress:
                                                    '${AppApi.urlApi}${event.subEvents[0].imagePath}', // Use AppApi
                                              ),
                                              SizedBox(height: 8),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Text(
                                                  event.title,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          }),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "กิจกรรมแนะนำ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(HomeEventAllcard());
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "ดูทั้งหมด",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      " >",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Obx(() {
                            if (listEventController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      listEventController.events.map((event) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(HomeDetailReward());
                                      },
                                      child: Container(
                                        width: 150,
                                        margin: EdgeInsets.only(right: 8),
                                        child: AppCardComponent(
                                          child: Column(
                                            children: [
                                              AppImageComponent(
                                                imageType: AppImageType.network,
                                                imageAddress:
                                                    '${AppApi.urlApi}${event.subEvents[0].imagePath}', // Use AppApi
                                              ),
                                              SizedBox(height: 8),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Text(
                                                  event.title,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          }),
                          SizedBox(height: 16),
                          // Add dashed line
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.095 - 0,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Container(
                  width: 350,
                  height: 84,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).cardColor, // เปลี่ยนสีพื้นหลังตามธีม
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max, // ใช้พื้นที่เต็ม
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // เว้นระยะระหว่าง elements
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "คะเเนน",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Obx(() {
                                // ดึงค่าคะแนนจาก profileData
                                var points =
                                    pointsController.pointsData["points"];
                                double? pointsValue =
                                    double.tryParse(points.toString());

                                // ถ้าคะแนนผิดพลาดหรือน้อยกว่าหรือเท่ากับ 0 ให้แสดง "0"
                                String displayPoints = (pointsValue == null ||
                                        pointsValue <= 0)
                                    ? "0"
                                    : (pointsValue > 999999)
                                        ? "999999" // จำกัดตัวเลขสูงสุด 6 หลัก
                                        : pointsValue.toStringAsFixed(
                                            2); // ปัดเศษ 2 ตำแหน่ง

                                return Text(
                                  displayPoints,
                                  style: TextStyle(
                                    fontSize: 24,
                                    foreground: Paint()
                                      ..shader =
                                          AppGradiant.gradientX_1.createShader(
                                        Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                      ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),

                      // ใช้ Expanded + Align เพื่อให้ "ประวัติ" ชิดขวาเสมอ
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 120, // ป้องกัน Overflow
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 209, 234, 255),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.av_timer_rounded,
                                    color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "ประวัติ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue),
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
            ),
          ],
        ),
      ),
    );
  }
}
