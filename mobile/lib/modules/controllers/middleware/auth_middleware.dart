import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getusercontroller/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // ตัวนี้ยังคงเป็นการตรวจสอบการ redirect ไปที่หน้า login ถ้าไม่ได้ล็อกอิน
    return null;
  }

  // ฟังก์ชันที่ใช้ตรวจสอบสถานะการล็อกอินเฉพาะฟังก์ชันใน controller
  Future<bool> checkLoginStatusInFunction() async {
    AuthService authService = Get.find<AuthService>();
    bool loggedIn = await authService.checkLoginStatus();

    if (!loggedIn) {
      // แจ้งเตือนผู้ใช้หากไม่ได้ล็อกอิน
      Get.snackbar(
        "⚠️ ต้องเข้าสู่ระบบ",
        "กรุณาเข้าสู่ระบบก่อนทำรายการ",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
    return loggedIn;
  }
}
