import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart'; // เพิ่มสำหรับเปิดแอปอีเมล
import 'package:flutter/material.dart'; 
import '../models/users.model.dart';
import '../../core/services/api_urls.dart';

class RegisterController extends GetxController {
  final UserModel user = UserModel();
  final ProfileModel profile = ProfileModel();
  Dio dio = Dio();
  final RxBool obscurePass1 = true.obs;
  final RxBool obscurePass2 = true.obs;
  final RxString confirmpass = ''.obs;

void register() async {

  if (user.email.isNotEmpty &&
      user.password.isNotEmpty &&
      profile.profileName.isNotEmpty &&
      profile.firstName.isNotEmpty &&
      profile.lastName.isNotEmpty &&
      profile.phone.isNotEmpty) {
    try {
      final apiUrlsController = Get.find<ApiUrls>();
      String genderValue = profile.gender.value == 'ไม่ระบุ'
          ? 'Other'
          : profile.gender.value == 'ชาย'
              ? 'Male'
              : 'Female';
      // แปลงวันที่ให้เป็นรูปแบบ ISO-8601 พร้อมเวลาและเขตเวลา
      String formattedDate =
          profile.birthDate.value.toUtc().toIso8601String();

      // ส่งข้อมูลไปยัง API
      final response = await dio.post(
        apiUrlsController.register.value,
        data: {
          'email': user.email.value,
          'password': user.password.value,
          'profile': {
            'profile_name': profile.profileName.value,
            'first_name': profile.firstName.value,
            'last_name': profile.lastName.value,
            'phone': profile.phone.value,
            'birth_date': formattedDate, // ใช้วันที่ที่แปลงแล้ว
            'gender': genderValue, // ส่งค่า gender ที่เลือก
          },
        },
      );

      // ตรวจสอบสถานะของการตอบกลับจาก API
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Account Created Successfully");
        // ใช้ Future.delayed เพื่อให้ Dialog แสดงหลังจากที่กระบวนการเสร็จสมบูรณ์
        Future.delayed(Duration(seconds: 1), () {
          showEmailVerificationDialog(); // เรียกแสดง Dialog หลังจาก 1 วินาที
        });
      } else if (response.data['message'] == 'อีเมลนี้ถูกใช้ไปแล้ว') {
        Get.snackbar("Error", "อีเมลนี้ถูกใช้ไปแล้ว");
      } else {
        // ลบ Get.toNamed('/login'); ออกไป ไม่ต้องไปหน้าอื่น
        showEmailVerificationDialog(); // เรียกแสดง Dialog หลังจาก 1 วินาที
        // ลบการไปหน้า login ออกไป
        // Get.toNamed('/login'); 
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred. Please try again.");
    }
  } else {
    Get.snackbar("Error", "Please fill all fields");
  }
}


void showEmailVerificationDialog() {
  Get.defaultDialog(
    title: "ยืนยันอีเมล",
    titleStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    content: Column(
      children: [
        Icon(Icons.email, size: 60, color: Colors.blue),
        SizedBox(height: 10),
        Text(
          "คุณต้องการไปยืนยันอีเมลตอนนี้ไหม?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: user.email.value, // เปิดแอปอีเมลที่ใช้อยู่
              );
              await launchUrl(emailLaunchUri);
              Navigator.pop(Get.context!); // ปิด Dialog
              Get.snackbar("เสร็จสิ้น", "สมัครบัญชีเสร็จสิ้น");
              Get.toNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              "ไปที่เมล",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.pop(Get.context!); // ปิด Dialog
            Get.snackbar("เสร็จสิ้น", "สมัครบัญชีเสร็จสิ้น");
            Get.toNamed('/login');
          },
          child: Text(
            "ยังไม่ยืนยันตอนนี้",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    ),
    radius: 20,
  );
}

}
