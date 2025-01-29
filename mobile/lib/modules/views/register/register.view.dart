import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/widgets/custom_loginpage.dart'; // เชื่อมต่อกับ CustomTextField และ CustomButton
import '../../controllers/register.controller.dart'; // ใช้ตัวควบคุมของ Register

class CreateAccountView extends StatelessWidget {
  final registerController =
      Get.put(RegisterController()); // ตัวควบคุมการลงทะเบียน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ปุ่มย้อนกลับ
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // หัวข้อ "ยืนยันบัญชี" ตรงกลางหน้าจอ
            Align(
              alignment: Alignment.center,
              child: Text(
                'ยืนยันสร้างบัญชี',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16), // ระยะห่างระหว่างหัวข้อกับช่องอีเมล

            // ช่องกรอกข้อมูล Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'Email',
                obscureText: false,
                onChanged: (value) => registerController.email.value = value,
              ),
            ),
            SizedBox(height: 16), // ระยะห่างระหว่างช่องอีเมลกับช่อง Username

            // ช่องกรอกข้อมูล Username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'Username',
                obscureText: false,
                onChanged: (value) => registerController.username.value = value,
              ),
            ),
            SizedBox(
                height: 16), // ระยะห่างระหว่างช่อง Username กับช่องรหัสผ่าน

            // ช่องกรอกรหัสผ่าน
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'Password',
                obscureText: true, // ซ่อนรหัสผ่าน
                onChanged: (value) => registerController.password.value = value,
              ),
            ),
            SizedBox(
                height: 16), // ระยะห่างระหว่างช่อง Username กับช่องรหัสผ่าน

            // ช่องกรอกรหัสผ่าน
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'Comfirm Password',
                obscureText: true, // ซ่อนรหัสผ่าน
                onChanged: (value) => registerController.password.value = value,
              ),
            ),
            Spacer(), // ดันให้ปุ่มอยู่ล่างสุด

            // ปุ่มยืนยันบัญชี
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomButton(
                    text: 'ยืนยันบัญชี',
                    onPressed: () {
                      // เรียกใช้งาน register
                      registerController.register();
                    },
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'มีบัญชีอยู่แล้ว? เข้าสู่ระบบที่นี่',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
