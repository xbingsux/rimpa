import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/users.model.dart';
import '../../core/services/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/profile/profile_controller.dart';

class LoginController extends GetxController {
  final UserModel user = UserModel(); // ใช้ UserModel แทนการสร้างตัวแปรเอง
  Dio dio = Dio();
Future<void> saveEmailAndPassword(
  String email, String password, bool remember) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // หาค่าลำดับบัญชีที่ว่าง
  int accountIndex = prefs.getInt('accountIndex') ?? 0;

  // สร้าง Key สำหรับการเก็บข้อมูล (รวมทั้งอีเมลและรหัสผ่าน)
  await prefs.setBool('rememberPassword$accountIndex', remember);
  await prefs.setString('email$accountIndex', email);
  await prefs.setString('password$accountIndex', password);

  // เพิ่ม accountIndex เพื่อใช้กับบัญชีถัดไป
  await prefs.setInt('accountIndex', accountIndex + 1);

  // ✅ เพิ่ม Log เช็คค่า
  print("✅ บันทึกข้อมูลสำเร็จ:");
  print("📌 Remember Password: $remember");
  print("📌 Email: $email");
  print("📌 Password: $password");

  await prefs.reload(); // ✅ โหลดใหม่หลังบันทึก
}





  void loginwithemail(bool rememberPassword) async {
    if (user.email.value.isNotEmpty && user.password.value.isNotEmpty) {
      try {
        final apiUrlsController = Get.find<ApiUrls>();
        final response = await dio.post(
          apiUrlsController.login.value,
          data: {
            'email': user.email.value,
            'password': user.password.value,
          },
        );

        if (response.statusCode == 200) {
          var token = response.data['token'] ?? '';
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

          // บันทึก token ลงใน SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('email', user.email.value);
          await prefs.setString(
              'password', user.password.value); // บันทึกรหัสผ่านด้วย
          await prefs.setBool('rememberPassword', rememberPassword);
          await saveEmailAndPassword(
              user.email.value, user.password.value, rememberPassword);

          if (!rememberPassword) {
            // บันทึกเวลาล็อกอิน ถ้าไม่ได้เลือก "จำฉันไว้"
            await prefs.setInt(
                'loginTime', DateTime.now().millisecondsSinceEpoch);
          }

          // เรียกฟังก์ชัน fetchProfile() เพื่ออัปเดตข้อมูลโปรไฟล์
          final profileController = Get.find<ProfileController>();
          await profileController.fetchProfile();

          Get.snackbar('สำเร็จ', 'เข้าสู่ระบบเรียบร้อย');
          Get.offNamed('/home');
        } else {
          Get.snackbar('ข้อผิดพลาด', 'เข้าสู่ระบบไม่สำเร็จ');
        }
      } catch (e) {
        Get.snackbar('ข้อผิดพลาด', 'โปรดตรวจสอบอีเมลและรหัสผ่าน');
        print("Error: $e");
      }
    } else {
      Get.snackbar('ข้อผิดพลาด', 'โปรดกรอกข้อมูลให้ครบถ้วน');
    }
  }

  void deleteAccount() async {
    if (user.email.value.isNotEmpty && user.password.value.isNotEmpty) {
      try {
        // แสดงข้อมูลที่กรอกใน console log
        print('Email: ${user.email.value}');
        print('Password: ${user.password.value}');

        final apiUrlsController = Get.find<ApiUrls>();

        // ส่งข้อมูลผ่าน POST request ไปยัง Backend
        final response = await dio.post(
          apiUrlsController.login.value,
          data: {
            'email': user.email.value,
            'password': user.password.value,
          },
        );

        if (response.statusCode == 200) {
          var token = response.data['token'] ?? ''; // ใช้ค่าว่างถ้าเป็น null

          // เก็บข้อมูล token และ email ที่กรอกเองใน SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString(
              'email', user.email.value); // เก็บ email ที่กรอก

          // ตรวจสอบการเก็บข้อมูล
          String? storedEmail = prefs.getString('email');
          print('Stored email after saving: $storedEmail');

          Get.snackbar('Success', 'Logged in successfully');
          Get.offNamed('/home');
        } else if (response.statusCode == 401) {
          if (response.data['message'] == 'Wrong password') {
            Get.snackbar('Error', 'Wrong password');
          } else if (response.data['message'] == 'Unauthorized') {
            Get.snackbar('Error', 'Your email is not verified');
          }
        } else if (response.statusCode == 404) {
          Get.snackbar('Error', 'User not found');
        } else {
          Get.snackbar('Error', 'Failed to login');
        }
      } catch (e) {
        Get.snackbar('Error', 'Check your email and password');
        print("Error: $e");
      }
    } else {
      Get.snackbar('Error', 'Please fill in all fields');
    }
  }
}
