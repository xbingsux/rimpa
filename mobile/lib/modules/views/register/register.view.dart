import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rimpa/widgets/loginWidget/custom_loginpage.dart'; 
import '../../controllers/register.controller.dart';

class CreateAccountView extends StatelessWidget {
  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // ปรับขนาดให้เต็มจอ
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ปุ่มย้อนกลับ
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                      // หัวข้อ "ยืนยันบัญชี"
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'ยืนยันสร้างบัญชี',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),

                      // ฟอร์มกรอกข้อมูล
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              labelText: 'ชื่อผู้ใช้',
                              obscureText: false,
                              onChanged: (value) =>
                                  registerController.profile.profileName.value = value,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'ชื่อ',
                              obscureText: false,
                              onChanged: (value) =>
                                  registerController.profile.firstName.value = value,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'นามสกุล',
                              obscureText: false,
                              onChanged: (value) =>
                                  registerController.profile.lastName.value = value,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'อีเมล',
                              obscureText: false,
                              onChanged: (value) =>
                                  registerController.user.email.value = value,
                            ),
                            SizedBox(height: 16),
                            CustomPhoneRegisTextField(
                              onChanged: (value) {
                                registerController.profile.phone.value = value;
                              },
                            ),
                            SizedBox(height: 16),
                            CustomDatePicker(
                              labelText: 'วันเกิด',
                              selectedDate: registerController.profile.birthDate.value,
                              onChanged: (DateTime value) {
                                registerController.profile.birthDate.value = value;
                              },
                            ),
                            SizedBox(height: 16),
                            Obx(() {
                              return CustomDropdown(
                                labelText: 'เพศ',
                                selectedValue: registerController.profile.gender.value.isEmpty
                                    ? 'ไม่ระบุ'
                                    : registerController.profile.gender.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    registerController.profile.gender.value = value;
                                  }
                                },
                                items: ['ชาย', 'หญิง', 'ไม่ระบุ'],
                              );
                            }),
                            SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'รหัสผ่าน',
                              obscureText: true,
                              onChanged: (value) =>
                                  registerController.user.password.value = value,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'ยืนยันรหัสผ่าน',
                              obscureText: true,
                              onChanged: (value) =>
                                  registerController.user.password.value = value,
                            ),
                          ],
                        ),
                      ),

                      Spacer(), // ดันปุ่มไปล่างสุด
                      // ปุ่มยืนยันบัญชี
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CustomButton(
                              text: 'ยืนยันบัญชี',
                              onPressed: () {
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
              ),
            );
          },
        ),
      ),
    );
  }
}
