import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/loginWidget/custom_loginpage.dart';
import '../../../controllers/auth.controller.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

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
          "เปลี่ยนรหัสผ่าน",
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
                "โปรดป้อนรหัสผ่านปัจจุบันและรหัสผ่านใหม่", // คำอธิบายที่กลางบนสุด
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              
              const Text(
                "รหัสผ่านเก่า", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'กรอกรหัสผ่านเก่า',
                obscureText: true,
              ),
              const SizedBox(height: 18),
              
              const Text(
                "รหัสผ่านใหม่", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'กรอกรหัสผ่านใหม่',
                obscureText: true,
              ),
              const SizedBox(height: 18),
              
              const Text(
                "ยืนยันรหัสผ่านใหม่", // Label
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Customtextprofile(
                labelText: 'ยืนยันรหัสผ่านใหม่',
                obscureText: true,
              ),
              
              // Spacer ที่จะผลักดันปุ่มไปอยู่ที่ด้านล่าง
              const Spacer(),
              
              CustomButton(
                text: 'บันทึกรหัสผ่านใหม่',
                onPressed: () => authController.deleteAccount(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
