import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_urls.dart';

class ResetPasswordController extends GetxController {
  var isLoading = false.obs;
  var oldPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;
  var token = ''.obs;
  var message = ''.obs;
  var status = ''.obs;

  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  final Dio dio = Dio();
  final apiUrlsController = Get.find<ApiUrls>();

  Future<void> resetPassword() async {
  isLoading.value = true;

  try {
    if (newPassword.value.isEmpty || confirmPassword.value.isEmpty) {
      showError("กรุณากรอกรหัสผ่านใหม่และยืนยันรหัสผ่าน");
      return;
    }

    if (newPassword.value.length < 6) {
      showError("รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร");
      return;
    }

    if (newPassword.value != confirmPassword.value) {
      showError("รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      showError("ไม่พบ Token");
      return;
    }

    var response = await dio.post(
      apiUrlsController.resetPassword.value,
      data: {
        "token": token,
        "old_password": oldPassword.value,
        "new_password": newPassword.value,
      },
    );

    if (response.statusCode == 200) {
      var responseData = response.data;
      if (responseData['status'] == 'error') {
        showError(responseData['message']);
      } else {
        showSuccess("เปลี่ยนรหัสผ่านสำเร็จ");
        clearFields(); // เพิ่มตรงนี้ให้เคลียร์ค่าที่กรอก
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


  void showError(String msg) {
    message.value = msg;
    status.value = "error";
    Get.snackbar("เกิดข้อผิดพลาด", msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white);
    isLoading.value = false;
  }

  void showSuccess(String msg) {
    message.value = msg;
    status.value = "success";
    Get.snackbar("สำเร็จ", msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

  void clearFields() {
    oldPassword.value = '';
    newPassword.value = '';
    confirmPassword.value = '';
    isOldPasswordVisible.value = false;
    isNewPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }
}
