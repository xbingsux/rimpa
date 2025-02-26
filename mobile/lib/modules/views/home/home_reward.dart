import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/views/home/rewardbanners/rewardbannner_slider.dart';

import '../../../widgets/shimmerloadwidget/shimmer.widget.dart';
import '../../../components/cards/app-card.component.dart';

import '../../../components/imageloader/app-image.component.dart';
import '../../../core/constant/app.constant.dart';
import '../../controllers/profile/profile_controller.dart';

import 'seeallcards/recommended_privileges.dart';
import 'homedetail/home_detail_reward.dart'; // Add this import

class HomeRewardPage extends StatefulWidget {
  @override
  _HomeRewardPageState createState() => _HomeRewardPageState();
}

class _HomeRewardPageState extends State<HomeRewardPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

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
                          SizedBox(height: 50),
                          RewardBannerSliderComponent(),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(8, (index) {
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
                                                "https://scontent.fbkk22-3.fna.fbcdn.net/v/t39.30808-6/470805346_1138761717820563_3034092518607465864_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGAqyEMQM1w0WCxcU9HbQtVgomPYyEmDp6CiY9jISYOnhLKioAFlnwgv1uyEqsea1kTwsVCn5v_2GsQLAcVdDih&_nc_ohc=r3eTzvX-TVkQ7kNvgFmDn7z&_nc_oc=AdiiKB0hIaIRZaZz3K_aH3pFxesBB-86mMZ1PYScK5xM4ioPhjuTnhrpRWt4Gf-2Yd0&_nc_zt=23&_nc_ht=scontent.fbkk22-3.fna&_nc_gid=AyRlRwqf4KmjNu7q7jrxM5s&oh=00_AYDQPWrMF1CPOcwNVZ5e07P3u3DtWuUpzGM7xs2EoXyVYQ&oe=67B37379",
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              "Lorem Ipsum is simply dummy text of the printing",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(8, (index) {
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
                                                "https://scontent.fbkk22-3.fna.fbcdn.net/v/t39.30808-6/470805346_1138761717820563_3034092518607465864_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGAqyEMQM1w0WCxcU9HbQtVgomPYyEmDp6CiY9jISYOnhLKioAFlnwgv1uyEqsea1kTwsVCn5v_2GsQLAcVdDih&_nc_ohc=r3eTzvX-TVkQ7kNvgFmDn7z&_nc_oc=AdiiKB0hIaIRZaZz3K_aH3pFxesBB-86mMZ1PYScK5xM4ioPhjuTnhrpRWt4Gf-2Yd0&_nc_zt=23&_nc_ht=scontent.fbkk22-3.fna&_nc_gid=AyRlRwqf4KmjNu7q7jrxM5s&oh=00_AYDQPWrMF1CPOcwNVZ5e07P3u3DtWuUpzGM7xs2EoXyVYQ&oe=67B37379",
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              "Lorem Ipsum is simply dummy text of the printing",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(8, (index) {
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
                                                "https://scontent.fbkk22-3.fna.fbcdn.net/v/t39.30808-6/470805346_1138761717820563_3034092518607465864_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGAqyEMQM1w0WCxcU9HbQtVgomPYyEmDp6CiY9jISYOnhLKioAFlnwgv1uyEqsea1kTwsVCn5v_2GsQLAcVdDih&_nc_ohc=r3eTzvX-TVkQ7kNvgFmDn7z&_nc_oc=AdiiKB0hIaIRZaZz3K_aH3pFxesBB-86mMZ1PYScK5xM4ioPhjuTnhrpRWt4Gf-2Yd0&_nc_zt=23&_nc_ht=scontent.fbkk22-3.fna&_nc_gid=AyRlRwqf4KmjNu7q7jrxM5s&oh=00_AYDQPWrMF1CPOcwNVZ5e07P3u3DtWuUpzGM7xs2EoXyVYQ&oe=67B37379",
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              "Lorem Ipsum is simply dummy text of the printing",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
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
