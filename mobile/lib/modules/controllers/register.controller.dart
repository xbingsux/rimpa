import 'package:get/get.dart';
import 'package:dio/dio.dart';

class RegisterController extends GetxController {
  var email = ''.obs;
  var username = ''.obs;
  var password = ''.obs;

  Dio dio = Dio(); // สร้างอินสแตนซ์ของ Dio

  void register() async {
    if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
      try {
        // ส่งข้อมูลผ่าน POST request
        final response = await dio.post(
          'http://localhost:3001/auth/register',
          data: {
            'email': email.value,
            'profile': {
              'profile_name': username
                  .value,
            },
            'password': password.value,
          },
        );

        // ตรวจสอบผลลัพธ์จากการตอบกลับของ API
        if (response.statusCode == 200) {
          // ถ้าการลงทะเบียนสำเร็จ
          Get.snackbar("Success", "Account Created Successfully");
          Get.offAllNamed('/login'); // ไปหน้า login
        } else {
          // ถ้าการลงทะเบียนไม่สำเร็จ
          Get.snackbar("Error", "Failed to create account");
        }
      } catch (e) {
        // ถ้ามีข้อผิดพลาดในการเชื่อมต่อหรือ API
        Get.snackbar("Error", "Something went wrong. Please try again later.");
        print("Error: $e");
      }
    } else {
      // ถ้าข้อมูลไม่ครบ
      Get.snackbar("Error", "Please fill all fields");
    }
  }
}
