import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/loginWidget/custom_loginpage.dart';
import '../../../controllers/auth.controller.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบโหมดธีมที่ใช้งาน
    final authController = Get.put(LoginController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.black.withOpacity(0.8) // สีดำอ่อนๆ เมื่อโหมดมืด
            : Theme.of(context)
                .scaffoldBackgroundColor, // ใช้สีพื้นฐานในโหมดปกติ
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue), // ปุ่มย้อนกลับ
          onPressed: () => Get.back(), // ใช้ GetX สำหรับย้อนกลับ
        ),
        title: const Text(
          "บัญชีผู้ใช้",
          style: TextStyle(color: Colors.black), // ปรับสีตามธีมที่ใช้งาน
        ),
        centerTitle: false, // ย้าย title ไปทางซ้าย
      ),
      body: Container(
        color: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor // ใช้สีพื้นหลังตามธีม
            : Colors.white, // กำหนดสีพื้นหลังเมื่อไม่ใช่โหมดมืด
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ชื่อผู้ใข้", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'ชื่อผู้ใข้',
                obscureText: true,
              ),
              const SizedBox(height: 18),
              const Text(
                "ชื่อ", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'ชื่อ',
                obscureText: true,
              ),
              const SizedBox(height: 18),
              const Text(
                "นามสกุล", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'นามสกุล',
                obscureText: true,
              ),
              const SizedBox(height: 18),
              const Text(
                "อีเมล", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'อีเมล',
                obscureText: true,
              ),
              const SizedBox(height: 18),
              const Text(
                "เบอร์โทรศัพท์", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CustomPhoneTextField(),
              const SizedBox(height: 18),
              const Text(
                "วันเกิด", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'วันเกิด',
                obscureText: true,
              ),
              const SizedBox(height: 18),
              const Text(
                "เพศ", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'เพศ',
                obscureText: true,
              ),
              // Spacer ที่จะผลักดันปุ่มไปอยู่ที่ด้านล่าง
              const Spacer(),
              CustomButton(
                text: 'บันทึกข้อมูลใหม่',
                onPressed: () => authController.loginwithemail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
