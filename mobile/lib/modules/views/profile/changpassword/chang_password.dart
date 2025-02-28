import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/loginWidget/custom_loginpage.dart';
import '../../../controllers/auth.controller.dart';
import '../../../controllers/resetpassword/resetpassword.controller.dart';
import 'dart:convert'; // สำหรับ JSON decoding

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    
    final authController = Get.put(LoginController());
    final resetPasswordController = Get.put(ResetPasswordController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.black.withOpacity(0.8)
            : Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: const Text("เปลี่ยนรหัสผ่าน",
            style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: Obx(() {
        final isLoading = resetPasswordController.isLoading.value;
        final message = resetPasswordController.message.value;
        final status = resetPasswordController.status.value;

        return Container(
          color: isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("โปรดป้อนรหัสผ่านปัจจุบันและรหัสผ่านใหม่",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                const Text("รหัสผ่านเก่า",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Obx(() {
                  return Stack(
                    children: [
                      CustomResetpasswordfiule(
                        labelText: 'กรอกรหัสผ่านเก่า',
                        obscureText:
                            !resetPasswordController.isOldPasswordVisible.value,
                        onChanged: (value) {
                          resetPasswordController.oldPassword.value = value;
                        },
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: Icon(
                            resetPasswordController.isOldPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            resetPasswordController.isOldPasswordVisible.value =
                                !resetPasswordController
                                    .isOldPasswordVisible.value;
                          },
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 18),
                const Text("รหัสผ่านใหม่",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Obx(() {
                  return Stack(
                    children: [
                      CustomResetpasswordfiule(
                        labelText: 'กรอกรหัสผ่านใหม่',
                        obscureText:
                            !resetPasswordController.isNewPasswordVisible.value,
                        onChanged: (value) {
                          resetPasswordController.newPassword.value = value;
                        },
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: Icon(
                            resetPasswordController.isNewPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            resetPasswordController.isNewPasswordVisible.value =
                                !resetPasswordController
                                    .isNewPasswordVisible.value;
                          },
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 18),
                const Text("ยืนยันรหัสผ่านใหม่",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Obx(() {
                  return Stack(
                    children: [
                      CustomResetpasswordfiule(
                        labelText: 'ยืนยันรหัสผ่านใหม่',
                        obscureText: !resetPasswordController
                            .isConfirmPasswordVisible.value,
                        onChanged: (value) {
                          resetPasswordController.confirmPassword.value = value;
                        },
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: Icon(
                            resetPasswordController
                                    .isConfirmPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            resetPasswordController
                                    .isConfirmPasswordVisible.value =
                                !resetPasswordController
                                    .isConfirmPasswordVisible.value;
                          },
                        ),
                      ),
                    ],
                  );
                }),
                const Spacer(),
                if (message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: status == "success" ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                CustomButtonResetpassword(
                  text: isLoading ? 'กำลังบันทึก...' : 'บันทึกรหัสผ่านใหม่',
                  onPressed: isLoading
                      ? null
                      : () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? token = prefs.getString('token');
                          if (token == null) {
                            Get.snackbar('ข้อผิดพลาด', 'ไม่พบ Token');
                            return;
                          }

                          await resetPasswordController.resetPassword();

                          // ถ้าเปลี่ยนรหัสผ่านสำเร็จ ให้รีเซ็ตช่องกรอกข้อมูล
                          if (resetPasswordController.status.value ==
                              "success") {
                            resetPasswordController.clearFields();
                          }
                        },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
