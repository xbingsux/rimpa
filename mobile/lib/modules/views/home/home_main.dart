import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:rimpa/components/dropdown/app-dropdown.component.dart';
import 'package:rimpa/core/services/api_urls.dart';
import '../../../core/constant/app.constant.dart';
import '../../../widgets/shimmerloadwidget/shimmer.widget.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../../widgets/popupdialog/popup_dialog.dart';
import '../../../components/cards/app-card.component.dart';
import '../../../components/imageloader/app-image.component.dart';
import '../../models/listevent.model.dart';
import '../../models/listbanner.model.dart'; // Add this import
import 'seeallcards/home_event_allcard.dart';
import 'homedetail/home_detail.dart';
import 'homedetail/banner_detail.dart'; // Add this import
import '../../controllers/listevent/listevent.controller.dart';
import '../../controllers/listbanner/listbanner.controller.dart'; // Add this import

class HomeMainPage extends StatefulWidget {
  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  final listEventController = Get.put(ListEventController());
  final listBannerController = Get.put(ListBannerController()); // Add this line
  String _sortOrder = "ใหม่สุด"; // Add this line

  @override
  void initState() {
    super.initState();

    // เรียก popup แจ้งเตือน
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PopupDialog.checkAndShowPopup(context);
    });
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
            Icon(Icons.notifications_none, color: Colors.grey),
          ],
        ),
      ),
      body: Obx(() {
        if (listEventController.isLoading.value ||
            listBannerController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<ListEvent> sortedEvents = listEventController.events.toList();
          if (_sortOrder == "ใหม่สุด") {
            sortedEvents.sort((a, b) => b.id.compareTo(a.id));
          } else {
            sortedEvents.sort((a, b) => a.id.compareTo(b.id));
          }

          return SingleChildScrollView(
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
                            Get.to(() => BannerDetailPage(
                                banner: banner)); // Corrected line
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: AppImageComponent(
                              aspectRatio: 16 / 9,
                              fit: BoxFit.cover,
                              imageType: AppImageType.network,
                              imageAddress:
                                  '${AppApi.urlApi}${banner.path.replaceAll("\\", "/")}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(listBannerController.banners.length,
                        (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index ? Colors.blue : Colors.grey,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: listEventController.events.map((event) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => HomeDetailPage(event: event));
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
                                        '${AppApi.urlApi}${event.subEvents[0].imagePath}',
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      event.title,
                                      style: TextStyle(fontSize: 12),
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
                            color: index % 2 == 0
                                ? Colors.transparent
                                : Colors.grey,
                            height: 1,
                          ),
                        );
                      }),
                    ),
                  ),
                  // Grid Section
                  AppDropdown(
                    onChanged: (value) {
                      setState(() {
                        _sortOrder = value;
                      });
                    },
                    choices: ["ใหม่สุด", "เก่าสุด"],
                    active: _sortOrder,
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
                    itemCount: sortedEvents.length,
                    itemBuilder: (context, index) {
                      var event = sortedEvents[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => HomeDetailPage(event: event));
                        },
                        child: AppCardComponent(
                          child: Column(
                            children: [
                              AppImageComponent(
                                imageType: AppImageType.network,
                                imageAddress:
                                    '${AppApi.urlApi}${event.subEvents[0].imagePath}',
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  event.title,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
