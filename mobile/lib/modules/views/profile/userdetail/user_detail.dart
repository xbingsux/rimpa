import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/loginWidget/custom_loginpage.dart';
import '../../../controllers/auth.controller.dart';
import '../../../controllers/profile/profile_controller.dart'; // นำเข้า ProfileController

class UserDetail extends StatelessWidget {
  const UserDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึง Controller
    final authController = Get.put(LoginController());
    final profileController = Get.put(ProfileController()); // เพิ่ม ProfileController
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.black.withOpacity(0.8) // สีดำอ่อนๆ เมื่อโหมดมืด
            : Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "บัญชีผู้ใช้",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Container(
        color: isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ชื่อผู้ใช้",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ✅ ใช้ Obx เพื่อให้ UI อัปเดตเมื่อ profileData เปลี่ยนแปลง
              Obx(() => Customtextprofile(
                    labelText: profileController.profileData["profile_name"] ?? 'กำลังโหลด...',
                    obscureText: false, // เปลี่ยนเป็น false เพื่อให้แสดงชื่อได้
                  )),
              
              const SizedBox(height: 18),
              const Text(
                "ชื่อ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() => Customtextprofile(
                    labelText: profileController.profileData["first_name"] ?? 'กำลังโหลด...',
                    obscureText: false,
                  )),

              const SizedBox(height: 18),
              const Text(
                "นามสกุล",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() => Customtextprofile(
                    labelText: profileController.profileData["last_name"] ?? 'กำลังโหลด...',
                    obscureText: false,
                  )),

              const SizedBox(height: 18),
              const Text(
                "อีเมล",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() => Customtextprofile(
                    labelText: profileController.profileData["email"] ?? 'กำลังโหลด...',
                    obscureText: false,
                  )),

              const SizedBox(height: 18),
              const Text(
                "เบอร์โทรศัพท์",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CustomPhoneTextField(),

              const SizedBox(height: 18),
              const Text(
                "วันเกิด",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() => Customtextprofile(
                    labelText: profileController.profileData["birth_date"] ?? 'กำลังโหลด...',
                    obscureText: false,
                  )),

              const SizedBox(height: 18),
              const Text(
                "เพศ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() => Customtextprofile(
                    labelText: profileController.profileData["gender"] ?? 'กำลังโหลด...',
                    obscureText: false,
                  )),

              const Spacer(),
              CustomButton(
                text: 'บันทึกข้อมูลใหม่',
                onPressed: () => authController.deleteAccount(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
