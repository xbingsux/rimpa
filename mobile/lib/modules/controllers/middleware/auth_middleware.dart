import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getusercontroller/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // ไม่ทำการ redirect อัตโนมัติ ให้ controller จัดการเอง
    return null;
  }

  // ฟังก์ชันที่ใช้ตรวจสอบสถานะการล็อกอิน เฉพาะฟังก์ชันใน controller
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
