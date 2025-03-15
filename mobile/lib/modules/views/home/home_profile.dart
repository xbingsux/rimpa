import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart'; // นำเข้า ImagePicker
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/services/api_urls.dart';
import '../../controllers/getusercontroller/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/app.constant.dart';
import '../../../widgets/profileMenuWidget/menu_card.dart';
import '../../controllers/profile/profile_controller.dart';
import 'dart:io'; // สำหรับจัดการไฟล์

class HomeProfilePage extends StatefulWidget {
  const HomeProfilePage({super.key});

  @override
  _HomeProfilePageState createState() => _HomeProfilePageState();
}

class _HomeProfilePageState extends State<HomeProfilePage> with SingleTickerProviderStateMixin {
  String email = '';
  bool isLoggedIn = false;
  late AnimationController _animationController;
  final AuthService _authService = AuthService(); // สร้าง instance ของ AuthService
  final profileController = Get.put(ProfileController()); // เพิ่ม ProfileController
  final picker = ImagePicker(); // สร้างตัวเลือกภาพ

  File? _selectedImage; // ตัวแปรสำหรับเก็บไฟล์รูปที่เลือก
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    _checkLoginStatus(); // ตรวจสอบสถานะการล็อกอินเมื่อเริ่มต้น
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.forward();
  }

  void _checkLoginStatus() async {
    bool isLoggedInStatus = await _authService.checkLoginStatus();
    if (isLoggedInStatus) {
      _loadUserInfo();
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  void _loadUserInfo() async {
    String userEmail = await _authService.loadUserInfo();
    setState(() {
      email = userEmail;
      isLoggedIn = true;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Clear profile data and other states
    Get.find<ProfileController>().resetProfile();

    setState(() {
      isLoggedIn = false;
    });
  }

  // ฟังก์ชันสำหรับเปิดการเลือกรูปจากอุปกรณ์
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // ถามผู้ใช้ว่าแน่ใจไหมที่จะเปลี่ยนรูป
      Get.dialog(
        AlertDialog(
          title: const Text('ยืนยันการเปลี่ยนรูปโปรไฟล์'),
          content: const Text('คุณต้องการเปลี่ยนรูปโปรไฟล์หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // ปิด dialog
              },
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                // เรียกฟังก์ชันอัปโหลดรูป
                profileController.uploadProfileImage(_selectedImage!);
              },
              child: const Text('ยืนยัน'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ApiUrls apiUrls = Get.find();
    return Container(
      // color: Colors.amber,
      decoration: const BoxDecoration(
        gradient: AppGradiant.gradientX_1,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(35),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Gap(82),
                      // Container(color: Colors.red, height: 82),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.whisperGray,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.1),
                          //     blurRadius: 10,
                          //     spreadRadius: 2,
                          //   ),
                          // ],
                        ),
                      ),
                    ],
                  ),
                  profile(apiUrls.imgUrl.value),
                ],
              ), // เว้นพื้นที่ด้านบนของ Profile Image
              Container(
                width: double.infinity,
                color: AppColors.whisperGray,
                child: Column(
                  children: [
                    if (!isLoggedIn) ...[
                      const Text(
                        "ยังไม่ได้ลงชื่อเข้าใช้",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Get.offAllNamed('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          fixedSize: const Size(270, 40),
                        ),
                        child: Text(
                          'ไปยังหน้าล็อกอิน',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 450), // เผื่อพื้นที่ป้องกัน bottom overflow
                    ] else ...[
                      Obx(() {
                        // ตรวจสอบหากไม่มีข้อมูลใน profileData หรือ profile_name
                        if (profileController.profileData.isEmpty || profileController.profileData["profile_name"] == null) {
                          // หากข้อมูลโปรไฟล์ยังไม่ถูกดึงหรือไม่มีข้อมูลใน profile_name
                          return Text(
                            "ยังไม่มีข้อมูล", // แสดงข้อความนี้ถ้ายังไม่มีข้อมูล
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: AppTextSize.md, // ปรับขนาดฟอนต์เป็น 16
                                ),
                          );
                        } else {
                          // หากมีข้อมูลใน profileData
                          return Text(
                            profileController.profileData["profile_name"] ?? "profile_name", // ถ้ามีข้อมูลก็แสดงชื่อผู้ใช้
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: AppTextSize.xl, fontWeight: FontWeight.w600),
                          );
                        }
                      }),
                      const SizedBox(height: 5),
                      Obx(() {
                        // ตรวจสอบหากไม่มีข้อมูลใน profileData หรือ profile_name
                        if (profileController.profileData.isEmpty || profileController.profileData["user"]["email"] == null) {
                          // หากข้อมูลโปรไฟล์ยังไม่ถูกดึงหรือไม่มีข้อมูลใน profile_name
                          return Text(
                            "ยังไม่มีข้อมูล", // แสดงข้อความนี้ถ้ายังไม่มีข้อมูล
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: AppTextSize.sm, // ปรับขนาดฟอนต์เป็น 16
                                ),
                          );
                        } else {
                          // หากมีข้อมูลใน profileData
                          return Text(
                            profileController.profileData["user"]["email"] ?? "email", // ถ้ามีข้อมูลก็แสดงชื่อผู้ใช้
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: AppTextSize.md, // ปรับขนาดฟอนต์เป็น 16
                                  color: AppTextColors.secondary,
                                ),
                          );
                        }
                      }),
                      Gap(10),
                      MenuCard(
                        title: "บัญชีและความเป็นส่วนตัว",
                        items: [
                          MenuItem(title: "บัญชีผู้ใช้งาน", icon: Iconsax.user_edit, route: "/user-deteil"),
                          MenuItem(title: "เปลี่ยนรหัสผ่าน", icon: Iconsax.lock_1, route: "/chang-password"),
                          // MenuItem(
                          //   title: "การแจ้งเตือน",
                          //   icon: Icons.notifications,
                          //   route: "/notifications",
                          //   isToggle: true,
                          // ),
                        ],
                      ),
                      Gap(16),
                      MenuCard(
                        title: "อื่นๆ",
                        items: [
                          MenuItem(title: "ช่วยเหลือ", icon: Iconsax.headphone, route: "/faq"),
                          MenuItem(title: "นโยบายความเป็นส่วนตัว", icon: Iconsax.security_user, route: "/policy"),
                          MenuItem(title: "ลบบัญชีผู้ใช้", icon: Iconsax.bag, route: "/delete-account", agrument: () => _logout(),),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          fixedSize: const Size(350, 40),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.logout_1, color: AppColors.danger),
                            Gap(16),
                            Text(
                              'ออกจากระบบ',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 18,
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Container(
                        // color: Colors.amber,
                        height: (MediaQuery.of(context).size.height - 725 <= 0 ? 0 : MediaQuery.of(context).size.height - 725)), // เผื่อพื้นที่ป้องกัน bottom overflow
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profile(String baseUrl) {
    return Obx(
      () {
        // ดึงข้อมูล URL ของรูปโปรไฟล์จาก Controller
        String profileImage = profileController.profileData["profile_img"] ?? '';

        // สร้าง URL ของภาพจาก path ที่ต้องการ
        String imageUrl = profileImage.isEmpty ? 'assets/images/default_profile.jpg' : '${baseUrl}$profileImage'; // กำหนด URL รูปโปรไฟล์

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              // รูปโปรไฟล์
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: profileImage.isEmpty ? const Color.fromARGB(255, 218, 165, 165) : Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: AppImageComponent(
                  imageType: AppImageType.network, // ระบุประเภทเป็น Network
                  imageAddress: imageUrl, // URL ของภาพโปรไฟล์
                  aspectRatio: 1 / 1, // อัตราส่วนภาพ (วงกลม)
                  borderRadius: const BorderRadius.all(Radius.circular(50)), // รูปทรงวงกลม
                ),
              ),
              // ไอคอนเปลี่ยนรูป
              InkWell(
                onTap: _pickImage,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Icon(
                    Iconsax.edit,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
