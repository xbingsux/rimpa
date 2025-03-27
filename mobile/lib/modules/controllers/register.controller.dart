import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
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

  void register() async {
    if (user.email.isNotEmpty &&
        user.password.isNotEmpty &&
        profile.profileName.isNotEmpty &&
        profile.firstName.isNotEmpty &&
        profile.lastName.isNotEmpty &&
        profile.phone.isNotEmpty) {
      try {
        final apiUrlsController = Get.find<ApiUrls>();
        print(" profile.gender.value : ${profile.gender.value}");
        String genderValue = profile.gender.value == 'ไม่ระบุ'
            ? 'Other'
            : profile.gender.value == 'ชาย'
                ? 'Male'
                : 'Female';
        // แปลงวันที่ให้เป็นรูปแบบ ISO-8601 พร้อมเวลาและเขตเวลา
        // String formattedDate = profile.birthDate.value.toUtc().toIso8601String();
        // String formattedDate = DateFormat('yyyy-MM-dd').format(profile.birthDate.value);
        // DateTime dateTime = DateTime.parse(formattedDate); // แปลง String กลับเป็น DateTime
        // String isoString = dateTime.toIso8601String(); // ทำให้เป็น ISO 8601

        String formattedDate = DateFormat('yyyy-MM-dd').format(profile.birthDate.value);
        DateTime dateTime = DateTime.parse("$formattedDate 00:00:00"); // อย่าใส่ Z ยังเป็น local time
        String isoString = dateTime.toIso8601String() + "Z"; // เติม Z เอง
        Map<String, dynamic> registerData = {
          'email': user.email.value,
          'password': user.password.value,
          'profile': {
            'profile_name': profile.profileName.value,
            'first_name': profile.firstName.value,
            'last_name': profile.lastName.value,
            'phone': profile.phone.value,
            'birth_date': isoString, // ใช้วันที่ที่แปลงแล้ว
            'gender': genderValue, // ส่งค่า gender ที่เลือก
          },
        };
        print(registerData);
        // ส่งข้อมูลไปยัง API
        // return;
        final response = await dio.post(
          apiUrlsController.register.value,
          data: registerData,
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
        print(e);
      }
    } else {
      Get.snackbar("Error", "Please fill all fields");
    }
  }

  void showEmailVerificationDialog() {
    showDialog(
    context: Get.context!,
    barrierDismissible: false, // บังคับไม่ให้ปิด Dialog นอก
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm)
          ),
          contentPadding: const EdgeInsets.only(left: AppSpacing.lg, right: AppRadius.lg, bottom: AppSpacing.lg),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppImageComponent(imageType: AppImageType.assets, imageAddress: 'assets/images/register/verify.png'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return AppGradiant.gradientY_1.createShader(bounds);
                    },
                    child: Text(
                      'ยืนยันอีเมล',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTextColors.white
                        ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'เกือบเสร็จแล้ว! ยืนยันอีเมลของคุณตอนนี้เลย',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: AppTextSize.md,
                      fontWeight: FontWeight.w400,
                      color: AppTextColors.secondary,
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed('/login');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppGradiant.gradientX_1,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: AppSpacing.xl),
                      child: Text(
                        'ย้อนกลับ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: AppTextSize.md,
                            fontWeight: FontWeight.w600,
                            color: AppTextColors.white,
                          ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
    // Get.defaultDialog(
    //   title: "ยืนยันอีเมล",
    //   titleStyle: TextStyle(
    //     fontSize: 18,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   content: Column(
    //     children: [
    //       Icon(Icons.email, size: 60, color: Colors.blue),
    //       SizedBox(height: 10),
    //       Text(
    //         "คุณต้องการไปยืนยันอีเมลตอนนี้ไหม?",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 16),
    //       ),
    //       SizedBox(height: 20),
    //       SizedBox(
    //         width: double.infinity,
    //         child: ElevatedButton(
    //           onPressed: () async {
    //             final Uri emailLaunchUri = Uri(
    //               scheme: 'mailto',
    //               path: user.email.value, // เปิดแอปอีเมลที่ใช้อยู่
    //             );
    //             await launchUrl(emailLaunchUri);
    //             Navigator.pop(Get.context!); // ปิด Dialog
    //             Get.snackbar("เสร็จสิ้น", "สมัครบัญชีเสร็จสิ้น");
    //             Get.toNamed('/login');
    //           },
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Colors.blue,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //             padding: EdgeInsets.symmetric(vertical: 14),
    //           ),
    //           child: Text(
    //             "ไปที่เมล",
    //             style: TextStyle(fontSize: 16, color: Colors.white),
    //           ),
    //         ),
    //       ),
    //       SizedBox(height: 10),
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(Get.context!); // ปิด Dialog
    //           Get.snackbar("เสร็จสิ้น", "สมัครบัญชีเสร็จสิ้น");
    //           Get.toNamed('/login');
    //         },
    //         child: Text(
    //           "ยังไม่ยืนยันตอนนี้",
    //           style: TextStyle(fontSize: 14, color: Colors.grey),
    //         ),
    //       ),
    //     ],
    //   ),
    //   radius: 20,
    // );
  }
}
