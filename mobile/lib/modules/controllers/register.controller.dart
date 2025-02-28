import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/users.model.dart';
import '../../core/services/api_urls.dart';

class RegisterController extends GetxController {
  final UserModel user = UserModel();
  final ProfileModel profile = ProfileModel();
  Dio dio = Dio();

  // ฟังก์ชันเพื่อส่งข้อมูลลง backend
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
          Get.offAllNamed('/login');
        } else if (response.data['message'] == 'อีเมลนี้ถูกใช้ไปแล้ว') {
          Get.snackbar("Error", "อีเมลนี้ถูกใช้ไปแล้ว");
        } else {
          Get.snackbar("เสร็จสิ้น", "สมัครบัญซีเสร็จสิ้น");
          Get.toNamed('/login');
        }
      } catch (e) {
        Get.snackbar("Error", "An error occurred. Please try again.");
      }
    } else {
      Get.snackbar("Error", "Please fill all fields");
    }
  }
}
