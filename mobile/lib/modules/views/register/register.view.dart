import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rimpa/widgets/loginWidget/custom_loginpage.dart'; // เชื่อมต่อกับ CustomTextField และ CustomButton
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
            SizedBox(height: 16), // ระยะห่างระหว่างช่องอีเมลกับช่อง Username

            // ช่องกรอกข้อมูล Username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'ชื่อผู้ใช้',
                obscureText: false,
                onChanged: (value) =>
                    registerController.profile.profileName.value = value,
              ),
            ),
            SizedBox(height: 16), // ระยะห่างระหว่างหัวข้อกับช่องอีเมล
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'ชื่อ',
                obscureText: false,
                onChanged: (value) =>
                    registerController.profile.firstName.value = value,
              ),
            ),
            SizedBox(height: 16), // ระยะห่างระหว่างหัวข้อกับช่องอีเมล
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'นามสกุล',
                obscureText: false,
                onChanged: (value) =>
                    registerController.profile.lastName.value = value,
              ),
            ),
            SizedBox(height: 16), // ระยะห่างระหว่างหัวข้อกับช่องอีเมล

            // ช่องกรอกข้อมูล Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'อีเมล',
                obscureText: false,
                onChanged: (value) =>
                    registerController.user.email.value = value,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomPhoneRegisTextField(
                onChanged: (value) {
                  registerController.profile.phone.value =
                      value; // ส่งค่าเบอร์โทรศัพท์ไปยัง controller
                },
              ),
            ),
            SizedBox(height: 16), // ระยะห่างระหว่างหัวข้อกับช่องอีเมล
            // ช่องกรอกข้อมูล Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomDatePicker(
                labelText: 'วันเกิด',
                selectedDate: registerController
                    .profile.birthDate.value, // ใช้ค่า DateTime จาก controller
                onChanged: (DateTime value) {
                  // แปลงวันที่ที่เลือกเป็นรูปแบบที่ต้องการ
                  registerController.profile.birthDate.value =
                      value; // อัปเดตค่าใน controller
                },
              ),
            ),

            SizedBox(height: 16), // ระยะห่างระหว่างหัวข้อกับช่องอีเมล

            // ช่องกรอกข้อมูล Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(() {
                return CustomDropdown(
                  labelText: 'เพศ',
                  selectedValue: registerController.profile.gender.value.isEmpty
                      ? 'ไม่ระบุ'
                      : registerController.profile.gender.value,
                  onChanged: (value) {
                    if (value != null) {
                      registerController.profile.gender.value =
                          value; // อัพเดตค่า gender
                    }
                  },
                  items: ['ชาย', 'หญิง', 'ไม่ระบุ'], // ตัวเลือกเพศ
                );
              }),
            ),

            SizedBox(
                height: 16), // ระยะห่างระหว่างช่อง Username กับช่องรหัสผ่าน

            // ช่องกรอกรหัสผ่าน
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'รหัสผ่าน',
                obscureText: true, // ซ่อนรหัสผ่าน
                onChanged: (value) =>
                    registerController.user.password.value = value,
              ),
            ),
            SizedBox(
                height: 16), // ระยะห่างระหว่างช่อง Username กับช่องรหัสผ่าน

            // ช่องกรอกรหัสผ่าน
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomTextField(
                labelText: 'ยืนยันรหัสผ่าน',
                obscureText: true, // ซ่อนรหัสผ่าน
                onChanged: (value) =>
                    registerController.user.password.value = value,
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
                  Haveaccountbutton(
                    onPressed: () => Get.toNamed('/login'),
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
