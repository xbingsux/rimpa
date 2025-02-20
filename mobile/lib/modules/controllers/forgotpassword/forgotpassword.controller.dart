import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:rimpa/widgets/loaddingforgotpassword/loadding_senemail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_urls.dart'; // นำเข้าที่เก็บ API URL
import 'package:flutter/material.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  var email = ''.obs;
  var message = ''.obs;
  var status = ''.obs;

  final Dio dio = Dio();
  final apiUrlsController = Get.find<ApiUrls>(); // เรียก ApiUrls จาก GetX

  // ฟังก์ชันส่งคำขอ Forgot Password
  Future<void> forgotPassword() async {
    isLoading.value = true;
    try {
      // ตรวจสอบว่าอีเมลกรอกครบหรือไม่
      if (email.value.isEmpty) {
        message.value = 'กรุณากรอกอีเมล';
        status.value = 'error';
        isLoading.value = false;
        return;
      }

      // ตรวจสอบรูปแบบอีเมลที่ถูกต้อง
      if (!GetUtils.isEmail(email.value)) {
        message.value = 'กรุณากรอกอีเมลให้ถูกต้อง';
        status.value = 'error';
        isLoading.value = false;
        return;
      }

      var response = await dio.post(
        apiUrlsController.forgotpassworduser.value, // ดึง URL จาก ApiUrls
        data: {"email": email.value}, // ส่งข้อมูลอีเมลไปยัง API
      );

      if (response.statusCode == 201) {
        status.value = "success";
        message.value = "ลิงค์รีเซ็ตรหัสผ่านถูกส่งไปยังอีเมลของคุณแล้ว";

        // เปลี่ยนหน้าไปที่ LoadingScreen หลังจากส่งคำขอสำเร็จ
        Get.to(() => LoadingScreen());

        // คุณสามารถรอระยะเวลาสักพักเพื่อให้ผู้ใช้เห็นข้อความ
        await Future.delayed(Duration(seconds: 5));

        // เมื่อเสร็จสิ้นการโหลดกลับไปหน้าเดิม (หน้า ForgotPasswordView)
        Get.back();
      } else {
        status.value = "error";
        message.value = "ไม่สามารถส่งอีเมลได้";
      }
    } catch (e) {
      print("Error: $e");
      status.value = "error";
      message.value = "เกิดข้อผิดพลาดในการส่งคำขอ";
    } finally {
      isLoading.value = false;
    }
  }
}
