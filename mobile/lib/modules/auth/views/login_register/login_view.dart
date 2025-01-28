import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/theme/theme_controller.dart';
import '../../../../core/widgets/custom_loginpage.dart';
import '../../controllers/auth_logre/login_controller.dart';

class LoginView extends StatelessWidget {
  final authController = Get.put(LoginController());
 
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
                  labelText: 'Email',
                  obscureText: false,
                  onChanged: (value) => authController.email.value = value,
                ),
                SizedBox(height: 16),
                // ช่องกรอกข้อมูล Password
                CustomTextField(
                  labelText: 'Password',
                  obscureText: true,
                  onChanged: (value) => authController.password.value = value,
                ),
                SizedBox(height: 32),
                // ปุ่ม Login เต็มข้าง
                CustomButton(
                  text: 'Login',
                  onPressed: () => authController.login(),
                ),
                SizedBox(height: 16),
                // ปุ่ม Create Account เต็มข้าง
                CreateAccountButton(
                  text: 'Create Account',
                  onPressed: () => Get.toNamed('/create-account'),
                ),
              ],
            ),
          ),
          // ปุ่มเปลี่ยนธีมที่มุมขวาบน
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                Get.find<ThemeController>().toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
