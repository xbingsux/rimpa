import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // นำเข้า ImagePicker
import '../../controllers/getusercontroller/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/app.constant.dart';
import '../../../widgets/profileMenuWidget/menu_card.dart';
import '../../controllers/profile/profile_controller.dart';
import 'dart:io'; // สำหรับจัดการไฟล์

class HomeProfilePage extends StatefulWidget {
  @override
  _HomeProfilePageState createState() => _HomeProfilePageState();
}

class _HomeProfilePageState extends State<HomeProfilePage>
    with SingleTickerProviderStateMixin {
  String email = '';
  bool isLoggedIn = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final AuthService _authService =
      AuthService(); // สร้าง instance ของ AuthService
  final profileController =
      Get.put(ProfileController()); // เพิ่ม ProfileController
  final picker = ImagePicker(); // สร้างตัวเลือกภาพ

  File? _selectedImage; // ตัวแปรสำหรับเก็บไฟล์รูปที่เลือก

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // ตรวจสอบสถานะการล็อกอินเมื่อเริ่มต้น
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

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
    await prefs.remove('email');
    await prefs.remove('rememberPassword');

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
          title: Text('ยืนยันการเปลี่ยนรูปโปรไฟล์'),
          content: Text('คุณต้องการเปลี่ยนรูปโปรไฟล์หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // ปิด dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                // เรียกฟังก์ชันอัปโหลดรูป
                profileController.uploadProfileImage(_selectedImage!);
              },
              child: Text('ยืนยัน'),
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
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradiant.gradientX_1,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(0, 194, 88, 88),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 80), // เว้นพื้นที่ด้านบนของ Profile Image
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromARGB(255, 26, 25, 25)
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 65),
                        child: Column(
                          children: [
                            if (!isLoggedIn) ...[
                              Text(
                                "ยังไม่ได้ลงชื่อเข้าใช้",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => Get.toNamed('/login'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  fixedSize: Size(270, 40),
                                ),
                                child: Text(
                                  'ไปยังหน้าล็อกอิน',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      430), // เผื่อพื้นที่ป้องกัน bottom overflow
                            ] else ...[
                              Text(
                                "ชื่อผู้ใช้",
                                style: TextStyle(
                                  fontSize: AppTextSize.md,
                                ),
                              ),
                              SizedBox(height: 5),
                              Obx(() {
                                // ตรวจสอบหากไม่มีข้อมูลใน profileData หรือ profile_name
                                if (profileController.profileData.isEmpty ||
                                    profileController.profileData["user"]
                                            ["email"] ==
                                        null) {
                                  // หากข้อมูลโปรไฟล์ยังไม่ถูกดึงหรือไม่มีข้อมูลใน profile_name
                                  return Text(
                                    "ยังไม่มีข้อมูล", // แสดงข้อความนี้ถ้ายังไม่มีข้อมูล
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: AppTextSize.sm, // ปรับขนาดฟอนต์เป็น 16
                                        ),
                                  );
                                } else {
                                  // หากมีข้อมูลใน profileData
                                  return Text(
                                    profileController.profileData["user"]
                                            ["email"] ??
                                        "email", // ถ้ามีข้อมูลก็แสดงชื่อผู้ใช้
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: AppTextSize.sm, // ปรับขนาดฟอนต์เป็น 16
                                        ),
                                  );
                                }
                              }),
                              MenuCard(
                                title: "บัญชีและความเป็นส่วนตัว",
                                items: [
                                  MenuItem(
                                      title: "บัญชีผู้ใช้งาน",
                                      icon: Icons.person,
                                      route: "/user-deteil"),
                                  MenuItem(
                                      title: "เปลี่ยนรหัสผ่าน",
                                      icon: Icons.lock,
                                      route: "/chang-password"),
                                  MenuItem(
                                    title: "การแจ้งเตือน",
                                    icon: Icons.notifications,
                                    route: "/notifications",
                                    isToggle: true,
                                  ),
                                ],
                              ),
                              MenuCard(
                                title: "อื่นๆ",
                                items: [
                                  MenuItem(
                                      title: "ช่วยเหลือ",
                                      icon: Icons.person,
                                      route: "/profile"),
                                  MenuItem(
                                      title: "ลบบัญชีผู้ใช้",
                                      icon: Icons.person,
                                      route: "/delete-account"),
                                ],
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _logout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  fixedSize: Size(350, 40),
                                ),
                                child: Text(
                                  'ออกจากระบบ',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                            SizedBox(
                                height:
                                    100), // เผื่อพื้นที่ป้องกัน bottom overflow
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: Obx(() {
                  String profileImage =
                      profileController.profileData["profile_image"] ?? '';
                  return Stack(
                    children: [
                      // รูปโปรไฟล์
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: profileImage.isEmpty
                              ? Color.fromARGB(255, 218, 165, 165)
                              : Colors.transparent,
                          image: profileImage.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(profileImage),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: profileImage.isEmpty
                            ? Center(
                                child: Text(
                                  "default",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      // ไอคอนเปลี่ยนรูป
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: _pickImage, // เรียกฟังก์ชันเลือกภาพ
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
