import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/theme/theme_controller.dart';
import '../../../widgets/loginWidget/custom_loginpage.dart';
import '../../controllers/auth.controller.dart';
import '../../../core/constant/app.constant.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final authController = Get.put(LoginController());
  bool _rememberPassword = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          /// **โลโก้ด้านบน**
          AspectRatio(
            aspectRatio: 4 / 3, // ใช้อัตราส่วนจากอันที่สอง
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.light, // ใส่สีพื้นหลัง
              ),
              child: Align(
                alignment: Alignment.center, // จัดให้อยู่ตรงกลาง
                child: SizedBox(
                  width: 220, // กำหนดขนาดรูป
                  height: 120,
                  child: Image.asset(
                    'assets/logoapp/logoiconic.png', 
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          /// 🔹 **Bottom Sheet ที่ยืดหยุ่นและเลื่อนได้**
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.7,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF1A1919) // ดาร์คโหมด
                    : Colors.white, // ไลท์โหมด
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 **ข้อความต้อนรับ**
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'ยินดีต้อนรับเข้าสู่ระบบ',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 16, 147, 237)),
                      ),
                      SizedBox(height: AppSpacing.md),

                      /// 
                      Column(
                        children: [
                          CustomTextField(
                            labelText: 'อีเมล',
                            obscureText: false,
                            onChanged: (value) =>
                                authController.user.email.value = value,
                          ),
                          SizedBox(height: AppSpacing.md),

                          /// **ฟิลด์รหัสผ่าน**
                          CustomTextFieldpassword(
                            labelText: 'รหัสผ่าน',
                            obscureText: _obscureText,
                            onChanged: (value) =>
                                authController.user.password.value = value,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),

                          /// 🔹 **"จำรหัสผ่าน" & "ลืมรหัสผ่าน"**
                          RememberPasswordWidget(
                            rememberPassword: _rememberPassword,
                            onRememberChanged: (value) {
                              setState(() {
                                _rememberPassword = value;
                              });
                            },
                            onForgotPassword: () =>
                                Get.toNamed('/forgot-password'),
                          ),
                          SizedBox(height: AppSpacing.md),

                          /// 🔹 **ปุ่มเข้าสู่ระบบ**
                          CustomButton(
                            text: 'เข้าสู่ระบบ',
                            onPressed: () => authController
                                .loginwithemail(_rememberPassword),
                          ),
                          SizedBox(height: AppSpacing.md),

                          /// 🔹 **เส้นคั่น "หรือ"**
                          Ordesign(text: 'หรือ'),
                          SizedBox(height: AppSpacing.md),

                          /// 🔹 **ปุ่มเข้าสู่ระบบด้วย Google**
                          SocialLoginButtons(
                            onGooglePressed: () =>
                                print("เข้าสู่ระบบด้วย Google"),
                          ),
                          SizedBox(height: AppSpacing.md),

                          /// 🔹 **ปุ่มสมัครบัญชีใหม่**
                          CreateAccountButton(
                            onPressed: () => Get.toNamed('/select-create'),
                          ),
                          SizedBox(
                              height: screenHeight * 0.02), // ปรับระยะห่างล่าง
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// 🔹 **ปุ่มเปลี่ยนธีม**
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () => Get.find<ThemeController>().toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}
