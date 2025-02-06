import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/users.model.dart';
import '../../core/services/api_urls.dart';

class RegisterController extends GetxController {
  final UserModel user = UserModel(); // ใช้ UserModel แทนการสร้างตัวแปรเอง

  Dio dio = Dio(); // สร้างอินสแตนซ์ของ Dio

  void register() async {
    if (user.email.isNotEmpty &&
        user.password.isNotEmpty &&
        user.username.isNotEmpty) {
      try {
        // ใช้ Get.find<ApiUrls>() เพื่อเรียกใช้ URL สำหรับ login จาก ApiUrls controller
        final apiUrlsController = Get.find<ApiUrls>();

        // ส่งข้อมูลผ่าน POST request
        final response = await dio.post(
          apiUrlsController.register, // ใช้ URL จากไฟล์กลาง
          data: {
            'email': user.email.value,
            'profile': {
              'profile_name': user.username.value,
            },
            'password': user.password.value,
          },
        );

        // ตรวจสอบผลลัพธ์จากการตอบกลับของ API
        if (response.statusCode == 200) {
          // ถ้าการลงทะเบียนสำเร็จ
          Get.snackbar("Success", "Account Created Successfully");
          Get.offAllNamed('/login'); // ไปหน้า login
        } else {
          // ถ้าการลงทะเบียนไม่สำเร็จ
          Get.snackbar("Success", "SUCCESS CREATE ACCOUNT!!!!!!");
        }
      } catch (e) {
        // ถ้ามีข้อผิดพลาดในการเชื่อมต่อหรือ API
        Get.snackbar("Success", "SUCCESS CREATE ACCOUNT!!!!!!");
      }
    } else {
      // ถ้าข้อมูลไม่ครบ
      Get.snackbar("Error", "Please fill all fields");
    }
  }
}
