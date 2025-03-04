import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rimpa/modules/controllers/reward/list_reward_controller.dart';
import 'package:rimpa/modules/views/home/seeallcards/home_event_allcard.dart';
import 'package:rimpa/widgets/my_app_bar.dart';
import 'dart:async';
import '../../../components/cards/app-card.component.dart';
import '../../../components/imageloader/app-image.component.dart';
import '../../../core/constant/app.constant.dart';
import '../../controllers/profile/profile_controller.dart';
import 'homedetail/banner_detail.dart';
import 'homedetail/home_detail.dart';
import 'seeallcards/recommended_privileges.dart';
import 'homedetail/home_detail_reward.dart'; // Add this import
import '../../controllers/listreward/listreward.controller.dart'; // Add this import
import '../../controllers/listbanner/listbanner.controller.dart'; // Add this import
import '../../controllers/listevent/listevent.controller.dart'; // Add this import

class HomeRewardPage extends StatefulWidget {
  const HomeRewardPage({super.key});

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
  final rewardController = Get.put(RewardController()); //  ใส่ตรงนี้
  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, // ทำให้ Status Bar โปร่งใส
    //   statusBarIconBrightness: Brightness.light, // ตั้งค่าไอคอนของ Status Bar ให้เหมาะกับพื้นหลัง
    // ));

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < listBannerController.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
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
    final pointsController = Get.put(PointsController()); // เพิ่ม ProfileController
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppGradiant.gradientX_1,
              ),
              child: Column(
                children: [
                  Container(
                    child: MyAppBar(
                      backgroundColor: Colors.transparent,
                      darkMode: true,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: const BoxDecoration(
                      gradient: AppGradiant.gradientX_1,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor, // รองรับ Light/Dark Mode
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Removed card here
                          const SizedBox(height: 40),
                          // Banner slider
                          Obx(() {
                            if (listBannerController.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              return SizedBox(
                                height: 150,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: listBannerController.banners.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    var banner = listBannerController.banners[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => BannerDetailPage(banner: banner)); // Corrected line
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        child: AppImageComponent(
                                          aspectRatio: 16 / 9,
                                          fit: BoxFit.cover,
                                          imageType: AppImageType.network,
                                          imageAddress: '${AppApi.urlApi}${banner.path.replaceAll("\\", "/")}', // Use AppApi.urlApi
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(listBannerController.banners.length, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPage == index ? 12 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentPage == index ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          // Activities Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "สิทธิพิเศษแนะนำ",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(const RecommendedPrivilegesPage());
                                },
                                child: const Row(
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
                          const SizedBox(height: 8),
                          Obx(() {
                            if (listRewardController.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: listRewardController.rewards.map((reward) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(HomeDetailReward(reward: reward)); // Pass reward object
                                      },
                                      child: Container(
                                        width: 150,
                                        margin: const EdgeInsets.only(right: 8),
                                        child: AppCardComponent(
                                          child: Column(
                                            children: [
                                              AppImageComponent(
                                                imageType: AppImageType.network,
                                                imageAddress: '${AppApi.urlApi}${reward.img.replaceAll("\\", "/")}', // Use AppApi.urlApi
                                              ),
                                              const SizedBox(height: 8),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Text(
                                                  reward.rewardName,
                                                  style: const TextStyle(fontSize: 12),
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
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "สิ่งที่บันทึก",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(const RecommendedPrivilegesPage());
                                },
                                child: const Row(
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
                          const SizedBox(height: 8),
                          Obx(() {
                            if (listEventController.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: listRewardController.rewards.map((reward) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(HomeDetailReward(reward: reward)); // Pass reward object
                                      },
                                      child: Container(
                                        width: 150,
                                        margin: const EdgeInsets.only(right: 8),
                                        child: AppCardComponent(
                                          child: Column(
                                            children: [
                                              AppImageComponent(
                                                imageType: AppImageType.network,
                                                imageAddress: '${AppApi.urlApi}${reward.img.replaceAll("\\", "/")}', // Use AppApi.urlApi
                                              ),
                                              const SizedBox(height: 8),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Text(
                                                  reward.rewardName,
                                                  style: const TextStyle(fontSize: 12),
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
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "กิจกรรมแนะนำ",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(HomeEventAllcard());
                                },
                                child: const Row(
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
                          const SizedBox(height: 8),
                          Obx(() {
                            if (listEventController.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: listEventController.events.map((event) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => HomeDetailPage(event: event));
                                      },
                                      child: Container(
                                        width: 150,
                                        margin: const EdgeInsets.only(right: 8),
                                        child: AppCardComponent(
                                          child: Column(
                                            children: [
                                              AppImageComponent(
                                                imageType: AppImageType.network,
                                                imageAddress: '${AppApi.urlApi}${event.subEvents[0].imagePath}', // Use AppApi
                                              ),
                                              const SizedBox(height: 8),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Text(
                                                  event.title,
                                                  style: const TextStyle(fontSize: 12),
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
                          const SizedBox(height: 16),
                          // Add dashed line
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.115 - 0,
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
                    color: Theme.of(context).cardColor, // เปลี่ยนสีพื้นหลังตามธีม
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max, // ใช้พื้นที่เต็ม
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // เว้นระยะระหว่าง elements
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              gradient: AppGradiant.gradientX_1, // Applied gradient
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "คะเเนน",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Obx(() {
                                // ดึงค่าคะแนนจาก profileData
                                var points = pointsController.pointsData["points"];
                                double? pointsValue = double.tryParse(points.toString());

                                // ถ้าคะแนนผิดพลาดหรือน้อยกว่าหรือเท่ากับ 0 ให้แสดง "0"
                                String displayPoints = (pointsValue == null || pointsValue <= 0)
                                    ? "0"
                                    : (pointsValue > 999999)
                                        ? "999999" // จำกัดตัวเลขสูงสุด 6 หลัก
                                        : pointsValue.toStringAsFixed(2); // ปัดเศษ 2 ตำแหน่ง

                                return Text(
                                  displayPoints,
                                  style: TextStyle(
                                    fontSize: 24,
                                    foreground: Paint()
                                      ..shader = AppGradiant.gradientX_1.createShader(
                                        const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
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
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.av_timer_rounded, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "ประวัติ",
                                  style: TextStyle(fontSize: 16, color: Colors.blue),
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
