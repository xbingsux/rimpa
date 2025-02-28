import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:get/get.dart';

import 'package:rimpa/components/dropdown/app-dropdown.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/views/notify/notify.view.dart';
import '../../../widgets/shimmerloadwidget/shimmer.widget.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../../widgets/popupdialog/popup_dialog.dart';
import '../../../components/cards/app-card.component.dart';
import '../../../components/imageloader/app-image.component.dart';
import 'seeallcards/home_event_allcard.dart';

import 'homedetail/home_detail.dart'; // Add this import

class HomeMainPage extends StatefulWidget {
  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // เรียก popup แจ้งเตือน
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PopupDialog.checkAndShowPopup(context);
    });
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 7) {
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, // รองรับ Light/Dark Mode
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // รูปโปรไฟล์แทนไอคอน
                Obx(() {
                  // ดึงข้อมูล URL ของรูปโปรไฟล์จาก Controller
                  String profileImage =
                      profileController.profileData["profile_img"] ?? '';

                  // สร้าง URL ของภาพจาก path ที่ต้องการ
                  String imageUrl = profileImage.isEmpty
                      ? 'assets/images/default_profile.jpg'
                      : '${apiUrls.imgUrl.value}$profileImage'; // กำหนด URL รูปโปรไฟล์

                  return Container(
                    width: 40, // ขนาดเดิม
                    height: 40, // ขนาดเดิม
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300], // พื้นหลังเทาเหมือนเดิม
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
                  var profileName =
                      profileController.profileData["profile_name"] ??
                          "ยังไม่มีข้อมูล";

                  return Text(
                    profileName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16, // ปรับขนาดฟอนต์เป็น 16
                        ),
                  );
                }),
              ],
            ),

            // ไอคอนแจ้งเตือน
            
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotifyView(),)),
              child: Container(
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: const Center(
                  child: Icon(Icons.notifications_none, color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner slider
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 8,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Get.to(HomeDetailPage());
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: AppImageComponent(
                        aspectRatio: 2.08 / 1,
                        fit: BoxFit.cover,
                        imageType: AppImageType.network,
                        imageAddress:
                            "https://scontent.fbkk22-3.fna.fbcdn.net/v/t39.30808-6/470805346_1138761717820563_3034092518607465864_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGAqyEMQM1w0WCxcU9HbQtVgomPYyEmDp6CiY9jISYOnhLKioAFlnwgv1uyEqsea1kTwsVCn5v_2GsQLAcVdDih&_nc_ohc=r3eTzvX-TVkQ7kNvgFmDn7z&_nc_oc=AdiiKB0hIaIRZaZz3K_aH3pFxesBB-86mMZ1PYScK5xM4ioPhjuTnhrpRWt4Gf-2Yd0&_nc_zt=23&_nc_ht=scontent.fbkk22-3.fna&_nc_gid=AyRlRwqf4KmjNu7q7jrxM5s&oh=00_AYDQPWrMF1CPOcwNVZ5e07P3u3DtWuUpzGM7xs2EoXyVYQ&oe=67B37379",
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(8, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.blue : Colors.grey,
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
                    "กิจกรรมแนะนำ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(8, (index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(HomeDetailPage());
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(60, (index) {
                    return Expanded(
                      child: Container(
                        color:
                            index % 2 == 0 ? Colors.transparent : Colors.grey,
                        height: 1,
                      ),
                    );
                  }),
                ),
              ),
              // Grid Section
              AppDropdown(
                onChanged: (value) {
                  // Handle sorting action
                },
                choices: ["ใหม่สุด", "เก่าสุด"],
                active: "เรียงตาม",
              ),
              SizedBox(height: 8),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: 8,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Get.to(HomeDetailPage());
                  },
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
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
