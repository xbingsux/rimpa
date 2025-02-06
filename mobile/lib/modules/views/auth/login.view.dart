import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/theme/theme_controller.dart';
import '../../../widgets/custom_loginpage.dart';
import '../../controllers/auth.controller.dart';

class LoginView extends StatelessWidget {
  final authController = Get.put(LoginController()); // Controller สำหรับการล็อกอิน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ช่องกรอกข้อมูล Email
                CustomTextField(
                  labelText: 'Email',  // ระบุชื่อของ field
                  obscureText: false,   // กำหนดให้เป็น text ธรรมดา
                  onChanged: (value) => authController.user.email.value = value,  // รับค่าจากผู้ใช้
                ),
                SizedBox(height: 16),
                
                // ช่องกรอกข้อมูล Password
                CustomTextField(
                  labelText: 'Password',  // ระบุชื่อของ field
                  obscureText: true,  // กำหนดให้เป็นแบบซ่อนข้อความ
                  onChanged: (value) => authController.user.password.value = value,  // รับค่าจากผู้ใช้
                ),
                SizedBox(height: 32),
                
                // ปุ่ม Login เต็มข้าง
                CustomButton(
                  text: 'ล็อคอิน',  // ข้อความบนปุ่ม
                  onPressed: () => authController.login(),  // เมื่อกดปุ่มให้เรียกใช้ฟังก์ชั่น login
                ),
                SizedBox(height: 16),
                
                // ปุ่ม Create Account เต็มข้าง
                CreateAccountButton(
                  text: 'ยังไม่มีบัญชี',  // ข้อความบนปุ่ม
                  onPressed: () => Get.toNamed('/create-account'),  // เมื่อกดให้ไปที่หน้า Create Account
                ),
              ],
            ),
          ),
          
          // ปุ่มเปลี่ยนธีมที่มุมขวาบน
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.brightness_6),  // ไอคอนที่ใช้สำหรับเปลี่ยนธีม
              onPressed: () {
                Get.find<ThemeController>().toggleTheme();  // เปลี่ยนธีม
              },
            ),
          ),
        ],
      ),
    );
  }
}
