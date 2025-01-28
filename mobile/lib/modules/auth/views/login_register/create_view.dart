import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/widgets/custom_loginpage.dart'; // เชื่อมต่อกับ CustomTextField และ CustomButton
import '../../controllers/login_register/create_controller.dart'; // ใช้ตัวควบคุมของ Register

class CreateAccountView extends StatelessWidget {
  final registerController = Get.put(CreateController()); // ตัวควบคุมการลงทะเบียน
 
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
                  onChanged: (value) => registerController.email.value = value,
                ),
                SizedBox(height: 16),
                // ช่องกรอกข้อมูล Password
                CustomTextField(
                  labelText: 'Password',
                  obscureText: true,
                  onChanged: (value) => registerController.password.value = value,
                ),
                SizedBox(height: 32),
                // ปุ่ม Submit ลงทะเบียน
                CustomButton(
                  text: 'Create Account',
                  onPressed: () => registerController.register(),
                ),
                SizedBox(height: 16),
                // ปุ่ม Login ที่มีลิงก์ไปหน้า Login
                GestureDetector(
                  onTap: () => Get.back(), // กลับไปหน้า Login
                  child: Text(
                    'Already have an account? Login here',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
