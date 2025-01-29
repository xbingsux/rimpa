import 'package:get/get.dart';
import 'package:dio/dio.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  Dio dio = Dio();

  void login() async {
    if (email.value.isNotEmpty && password.value.isNotEmpty) {
      try {
        // แสดงข้อมูลที่กรอกใน console log
        print('Email: ${email.value}');
        print('Password: ${password.value}');  // ควรระมัดระวังการแสดงรหัสผ่านใน console เพราะเป็นข้อมูลที่ควรเก็บเป็นความลับ

        // ส่งข้อมูลผ่าน POST request ไปยัง Backend
        final response = await dio.post(
          'http://localhost:3001/auth/login',  // URL ของ Backend
          data: {
            'email': email.value,
            'password': password.value,
          },
        );

        if (response.statusCode == 200) {
          // ถ้าล็อกอินสำเร็จ
          var token = response.data['token'];
          Get.snackbar('Success', 'Logged in successfully');
          print('Token: $token');  // แสดง token ที่ได้รับใน console
          // เก็บ token เพื่อใช้ในการเข้าสู่ระบบครั้งต่อไป
          // ใช้ GetStorage หรือ SharedPreferences สำหรับการเก็บ token
          // เช่น: GetStorage().write('token', token);
        } else if (response.statusCode == 401) {
          // หากรหัสผ่านไม่ถูกต้อง หรืออีเมลไม่ได้รับการยืนยัน
          if (response.data['message'] == 'Wrong password') {
            Get.snackbar('Error', 'Wrong password');
          } else if (response.data['message'] == 'Unauthorized') {
            Get.snackbar('Error', 'Your email is not verified');
          }
        } else if (response.statusCode == 404) {
          // หากไม่พบอีเมลในระบบ
          Get.snackbar('Error', 'User not found');
        } else {
          // ถ้าเกิดข้อผิดพลาดในการล็อกอิน
          Get.snackbar('Error', 'Failed to login');
        }
      } catch (e) {
        // ถ้ามีข้อผิดพลาดในการเชื่อมต่อกับ API
        Get.snackbar('Error', 'Something went wrong. Please try again later');
        print("Error: $e");
      }
    } else {
      // ถ้าข้อมูลไม่ครบ
      Get.snackbar('Error', 'Please fill in all fields');
    }
  }
}
