import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getusercontroller/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Don't redirect automatically, let the controller handle the logic
    return null;
  }

  // Function to check if the user is logged in
  Future<bool> checkLoginStatusInFunction() async {
    AuthService authService = Get.find<AuthService>();
    bool loggedIn = await authService.checkLoginStatus();

    if (!loggedIn) {
      // Show a snackbar to inform the user to log in
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

  // This function can be used in ProfileController to fetch the token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
