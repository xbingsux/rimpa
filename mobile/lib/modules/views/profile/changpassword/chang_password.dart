import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/widgets/button/botton.dart';
import 'package:rimpa/widgets/textFeild/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        // final message = resetPasswordController.message.value;
        // final status = resetPasswordController.status.value;

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
                      RimpaTextFormField(
                        hintText: 'รหัสผ่านปัจจุบัน',
                        isPassword: true,
                        controller: passwordController.value,
                        onChanged: (value) => passwordController.value.text = value,
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านปัจจุบัน"),
                          ],
                        ),
                      ),
                      RimpaTextFormField(
                        hintText: 'รหัสผ่านใหม่',
                        isPassword: true,
                        controller: newPasswordController.value,
                        onChanged: (value) => newPasswordController.value.text = value,
                        validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านปัจจุบัน"),
                          ],
                        ),
                      ),
                      RimpaTextFormField(
                        hintText: 'ยืนยันรหัสผ่านใหม่',
                        isPassword: true,
                        controller: confirmPasswordController.value,
                        onChanged: (value) => confirmPasswordController.value.text = value,
                        validator: (val) {
                          return MatchValidator(errorText: 'รหัสผ่านไม่ตรงกัน').validateMatch(val!, newPasswordController.value.text);
                        },
                      ),
                      Gap(8),
                    ],
                  ),
                ),
                Gap(20),
                GradiantButton(
                  text: 'ยืนยัน',
                  onTap: () async {
                    EasyLoading.show();

                    // await Future.delayed(Duration(seconds: 10));
                    formKey.currentState!.save();

                    if (formKey.currentState!.validate()) {
                      await resetPasswordController.resetPassword(oldPassword: passwordController.value.text, newPassword: newPasswordController.value.text);
                    }

                    EasyLoading.dismiss();
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
