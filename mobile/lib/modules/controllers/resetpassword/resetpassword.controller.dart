import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_urls.dart';
import '../../controllers/middleware/auth_middleware.dart';

class ResetPasswordController extends GetxController {
  var isLoading = false.obs;
  var token = ''.obs;
  var message = ''.obs;
  var status = ''.obs;

  final AuthMiddleware _authMiddleware = Get.find<AuthMiddleware>();
  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  final Dio dio = Dio();
  final apiUrlsController = Get.find<ApiUrls>();

  // ฟังก์ชันสำหรับรีเซ็ตรหัสผ่าน
  Future<void> resetPassword({required String oldPassword, required String newPassword}) async {
    isLoading.value = true;
    String? token = await _authMiddleware.getToken();

    try {
      // ส่งคำขอไปยัง backend
      var response = await dio.put(
        apiUrlsController.resetPassword.value,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: {
          "old_password": oldPassword,
          "new_password": newPassword,
        },
      );

      // ตรวจสอบผลลัพธ์จาก API
      if (response.statusCode == 201) {
        var responseData = response.data;
        if (responseData['status'] == 'error') {
          showError(responseData['message']);
        } else {
          showSuccess("เปลี่ยนรหัสผ่านสำเร็จ");
          clearFields(); // เคลียร์ข้อมูลหลังจากการรีเซ็ตรหัสผ่านสำเร็จ
          Get.offNamedUntil('/home', (route) => false, parameters: {'pages': '4'});
        }
      } else {
        showError("ไม่สามารถรีเซ็ตรหัสผ่านได้");
      }
    } catch (e) {
      showError("รหัสผ่านเก่าไม่ถูกต้อง");
    } finally {
      isLoading.value = false;
    }
  }

  // ฟังก์ชันสำหรับแสดงข้อความแสดงข้อผิดพลาด
  void showError(String msg) {
    message.value = msg;
    status.value = "error";
    Get.snackbar("เกิดข้อผิดพลาด", msg, snackPosition: SnackPosition.BOTTOM, backgroundColor: Get.theme.colorScheme.error, colorText: Colors.white);
    isLoading.value = false;
  }

  // ฟังก์ชันสำหรับแสดงข้อความสำเร็จ
  void showSuccess(String msg) {
    message.value = msg;
    status.value = "success";
    Get.snackbar("สำเร็จ", msg, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
  }

  // ฟังก์ชันสำหรับเคลียร์ข้อมูลที่กรอก
  void clearFields() {
    isOldPasswordVisible.value = false;
    isNewPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }
}
