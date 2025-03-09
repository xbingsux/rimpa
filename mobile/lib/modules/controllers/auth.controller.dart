import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:rimpa/modules/controllers/getusercontroller/auth_service.dart';
import '../models/users.model.dart';
import '../../core/services/api_urls.dart';
import '../controllers/profile/profile_controller.dart';

class LoginController extends GetxController {
  final UserModel user = UserModel(); // ใช้ UserModel แทนการสร้างตัวแปรเอง
  Dio dio = Dio();

  void loginwithemail({required String email, required String password}) async {
    try {
      final apiUrlsController = Get.find<ApiUrls>();
      final response = await dio.post(
        apiUrlsController.login.value,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // var token = response.data['token'] ?? '';
        var role = response.data['role'] ?? '';

        // ตรวจสอบว่า role เป็น 'admin' หรือไม่
        if (role == 'admin') {
          Get.snackbar('ข้อผิดพลาด', 'คุณมาผิดที่นะ');
          return;
        }

        // ตรวจสอบว่า role เป็น 'user' หรือไม่
        if (role != 'user') {
          Get.snackbar('ข้อผิดพลาด', 'คุณไม่ใช่ผู้ใช้ระบบ');
          return;
        }

        AuthService().saveAuth(response.data['token'], email);
        if (!Get.isRegistered<ProfileController>()) {
          Get.put(ProfileController());
        }
        // เรียกฟังก์ชัน fetchProfile() เพื่ออัปเดตข้อมูลโปรไฟล์
        final profileController = Get.find<ProfileController>();
        await profileController.fetchProfile();

        Get.offAllNamed('/home');
      } else {
        Get.snackbar('ข้อผิดพลาด', 'เข้าสู่ระบบไม่สำเร็จ');
      }
    } catch (e) {
      Get.snackbar('ข้อผิดพลาด', 'โปรดตรวจสอบอีเมลและรหัสผ่าน ${e}');
      print("Error: $e");
    }
  }
}
