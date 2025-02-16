import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/loginWidget/custom_loginpage.dart';
import '../../../controllers/auth.controller.dart';
import '../../../controllers/resetpassword/resetpassword.controller.dart';
import 'dart:convert'; // สำหรับ JSON decoding

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบโหมดธีมที่ใช้งาน
    final authController = Get.put(LoginController());
    final resetPasswordController = Get.put(
        ResetPasswordController()); // Initialize ResetPasswordController
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.black.withOpacity(0.8) // สีดำอ่อนๆ เมื่อโหมดมืด
            : Theme.of(context)
                .scaffoldBackgroundColor, // ใช้สีพื้นฐานในโหมดปกติ
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.blue), // ปุ่มย้อนกลับ
          onPressed: () => Get.back(), // ใช้ GetX สำหรับย้อนกลับ
        ),
        title: const Text(
          "เปลี่ยนรหัสผ่าน",
          style: TextStyle(color: Colors.black), // ปรับสีตามธีมที่ใช้งาน
        ),
        centerTitle: false, // ย้าย title ไปทางซ้าย
      ),
      body: Obx(() {
        // ใช้ Obx เพื่อฟังการเปลี่ยนแปลงสถานะของ controller
        final isLoading = resetPasswordController.isLoading.value;
        final message = resetPasswordController.message.value;
        final status = resetPasswordController.status.value;

        return Container(
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
                CustomResetpasswordfiule(
                  labelText: 'กรอกรหัสผ่านเก่า',
                  obscureText: true,
                  onChanged: (value) {
                    // เมื่อกรอกรหัสผ่านเก่า
                    resetPasswordController.oldPassword.value = value;
                  },
                ),
                const SizedBox(height: 18),

                const Text(
                  "รหัสผ่านใหม่", // Label
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                CustomResetpasswordfiule(
                  labelText: 'กรอกรหัสผ่านใหม่',
                  obscureText: true,
                  onChanged: (value) {
                    resetPasswordController.newPassword.value =
                        value; // Set new password
                  },
                ),
                const SizedBox(height: 18),

                const Text(
                  "ยืนยันรหัสผ่านใหม่", // Label
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                CustomResetpasswordfiule(
                  labelText: 'ยืนยันรหัสผ่านใหม่',
                  obscureText: true,
                  onChanged: (value) {
                    resetPasswordController.confirmPassword.value =
                        value; // Set confirm password
                  },
                ),

                // Spacer ที่จะผลักดันปุ่มไปอยู่ที่ด้านล่าง
                const Spacer(),

                // แสดงข้อความสถานะการรีเซ็ตรหัสผ่าน
                if (message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: status == "success" ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // ปุ่มบันทึกรหัสผ่านใหม่
                CustomButtonResetpassword(
                  text: isLoading ? 'กำลังบันทึก...' : 'บันทึกรหัสผ่านใหม่',
                  onPressed: isLoading
                      ? null // ป้องกันการกดซ้ำเมื่อกำลังโหลด
                      : () async {
                          // ดึง token จาก SharedPreferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? token = prefs.getString('token');
                          String currentPassword =
                              resetPasswordController.oldPassword.value;

                          // ตรวจสอบว่า token มีค่าหรือไม่
                          if (token == null) {
                            Get.snackbar('ข้อผิดพลาด', 'ไม่พบ Token');
                            return;
                          }

                          // ทำการส่งคำขอรีเซ็ตรหัสผ่านใหม่
                          resetPasswordController.resetPassword();
                        },
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
