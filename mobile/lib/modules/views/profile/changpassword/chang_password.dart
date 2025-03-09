import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/widgets/button/botton.dart';
import 'package:rimpa/widgets/textFeild/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/loginWidget/custom_loginpage.dart';
import '../../../controllers/auth.controller.dart';
import '../../../controllers/resetpassword/resetpassword.controller.dart';
// สำหรับ JSON decoding

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    final resetPasswordController = Get.put(ResetPasswordController());
    Rx<TextEditingController> passwordController = Rx<TextEditingController>(TextEditingController());
    Rx<TextEditingController> newPasswordController = Rx<TextEditingController>(TextEditingController());
    Rx<TextEditingController> confirmPasswordController = Rx<TextEditingController>(TextEditingController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();
    TextStyle style = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: AppTextSize.md,
          fontWeight: FontWeight.w600,
          color: AppTextColors.secondary,
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black.withOpacity(0.8) : Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppTextColors.secondary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "เปลี่ยนรหัสผ่าน",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: AppTextSize.xl,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        final isLoading = resetPasswordController.isLoading.value;
        final message = resetPasswordController.message.value;
        final status = resetPasswordController.status.value;

        return Container(
          color: isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "โปรดป้อนรหัสผ่านปัจจุบันและรหัสผ่านใหม่",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: AppTextSize.lg,
                          fontWeight: FontWeight.w600,
                          color: AppTextColors.secondary,
                        ),
                  ),
                ),
                Gap(32),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "รหัสผ่านปัจจุบัน",
                        style: style,
                      ),
                      const Gap(4),
                      RimpaTextFormField(
                        hintText: 'รหัสผ่านปัจจุบัน',
                        isPassword: true,
                        controller: passwordController.value,
                        onChanged: (value) => resetPasswordController.oldPassword.value = value,
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านปัจจุบัน"),
                          ],
                        ),
                      ),
                      Text(
                        "รหัสผ่านใหม่",
                        style: style,
                      ),
                      const Gap(4),
                      RimpaTextFormField(
                        hintText: 'รหัสผ่านใหม่',
                        isPassword: true,
                        controller: newPasswordController.value,
                        onChanged: (value) => resetPasswordController.newPassword.value = value,
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านปัจจุบัน"),
                          ],
                        ),
                      ),
                      Text(
                        "ยืนยันรหัสผ่านใหม่",
                        style: style,
                      ),
                      const Gap(4),
                      RimpaTextFormField(
                        hintText: 'ยืนยันรหัสผ่านใหม่',
                        isPassword: true,
                        controller: confirmPasswordController.value,
                        validator: (val) {
                          return MatchValidator(errorText: 'รหัสผ่านไม่ตรงกัน').validateMatch(val!, passwordController.value.text);
                        },
                      ),
                      Gap(8),
                    ],
                  ),
                ),
                GradiantButton(
                  text: isLoading ? 'กำลังรีเซ็ต...' : 'รีเซ็ต',
                  onTap: isLoading
                      ? () {}
                      : () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? token = prefs.getString('token');
                          if (token == null) {
                            Get.snackbar('ข้อผิดพลาด', 'ไม่พบ Token');
                            return;
                          }

                          await resetPasswordController.resetPassword();

                          // ถ้าเปลี่ยนรหัสผ่านสำเร็จ ให้รีเซ็ตช่องกรอกข้อมูล
                          if (resetPasswordController.status.value == "success") {
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
