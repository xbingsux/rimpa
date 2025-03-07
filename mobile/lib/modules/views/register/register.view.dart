import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/widgets/loginWidget/custom_loginpage.dart';
import '../../controllers/register.controller.dart';
import '../../../core/constant/app.constant.dart';

class CreateAccountView extends StatelessWidget {
  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, // รองรับ Light/Dark Mode
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "สร้างบัญชีผู้ใช้",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
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
                      const SizedBox(height: 16),
                      // ฟอร์มกรอกข้อมูล
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ชื่อผู้ใช้",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              labelText: 'ชื่อผู้ใช้',
                              obscureText: false,
                              onChanged: (value) => registerController
                                  .profile.profileName.value = value,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ชื่อ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              labelText: 'ชื่อ',
                              obscureText: false,
                              onChanged: (value) => registerController
                                  .profile.firstName.value = value,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "นามสกุล",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              labelText: 'นามสกุล',
                              obscureText: false,
                              onChanged: (value) => registerController
                                  .profile.lastName.value = value,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "อีเมล",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              labelText: 'อีเมล',
                              obscureText: false,
                              onChanged: (value) =>
                                  registerController.user.email.value = value,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "เบอร์โทรศัพท์",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CustomPhoneRegisTextField(
                              onChanged: (value) {
                                registerController.profile.phone.value = value;
                              },
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "วันเกิด",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Obx(() => CustomDatePicker(
                                  labelText: 'วันเกิด',
                                  selectedDate: registerController.profile
                                      .birthDate.value, // ใช้ Rx<DateTime?>
                                  onChanged: (DateTime value) {
                                    registerController.profile.birthDate.value =
                                        value;
                                  },
                                )),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "เพศ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Obx(() {
                              return CustomDropdown(
                                labelText: 'เพศ',
                                selectedValue: registerController
                                        .profile.gender.value.isEmpty
                                    ? 'ไม่ระบุ'
                                    : registerController.profile.gender.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    registerController.profile.gender.value =
                                        value;
                                  }
                                },
                                items: ['ชาย', 'หญิง', 'ไม่ระบุ'],
                              );
                            }),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "รหัสผ่าน",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              labelText: 'รหัสผ่าน',
                              obscureText: true,
                              onChanged: (value) => registerController
                                  .user.password.value = value,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // เว้นระยะจากซ้าย 16
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ยืนยันรหัสผ่าน",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              labelText: 'ยืนยันรหัสผ่าน',
                              obscureText: true,
                              onChanged: (value) => registerController
                                  .user.password.value = value,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(), // ดันปุ่มไปล่างสุด
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
                            const SizedBox(height: 16),
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
