import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/users.model.dart';
import '../../core/routes/app_pages.dart';
import '../../core/services/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/getusercontroller/auth_service.dart';

class LoginController extends GetxController {
  final UserModel user = UserModel(); // ใช้ UserModel แทนการสร้างตัวแปรเอง
  Dio dio = Dio();

  void loginwithemail(bool rememberPassword) async {
  // ตรวจสอบว่าเป็นการล็อกอินใหม่หรือไม่
  if (user.email.value.isNotEmpty && user.password.value.isNotEmpty) {
    try {
      final apiUrlsController = Get.find<ApiUrls>();

      final response = await dio.post(
        apiUrlsController.login,
        data: {
          'email': user.email.value,
          'password': user.password.value,
        },
      );

      if (response.statusCode == 200) {
        var token = response.data['token'] ?? '';

        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (rememberPassword) {
          await prefs.setString('token', token);
          await prefs.setString('email', user.email.value);
          await prefs.setBool('rememberPassword', true);
        } else {
          await prefs.setString('token', token);
          await prefs.setString('email', user.email.value);
          await prefs.setBool('rememberPassword', false);
        }

        Get.snackbar('Success', 'Logged in successfully');
        Get.offNamed('/home');
      } else {
        Get.snackbar('Error', 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Check your email and password');
      print("Error: $e");
    }
  } else {
    // หากไม่มีอีเมลและรหัสผ่าน ให้ใช้ token จากเครื่อง
    final authService = Get.find<AuthService>();
    if (await authService.isLoggedIn()) {
      // ถ้ามี token ในเครื่องแล้ว ให้เข้าสู่ระบบทันที
      Get.snackbar('Success', 'Logged in with saved token');
      Get.offNamed('/home');
    } else {
      Get.snackbar('Error', 'Please fill in all fields');
    }
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
          apiUrlsController.login,
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
