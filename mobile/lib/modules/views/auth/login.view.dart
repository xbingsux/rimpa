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

bool _rememberPassword = false; // ตัวแปรจำรหัส

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final authController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ส่วนของ Banner ด้านบน
          AspectRatio(
            aspectRatio: 4 / 3, // ตั้งอัตราส่วน 16:9
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logoapp/logoiconic.png'),
                  fit: BoxFit.contain, // ป้องกันภาพเสียรูป
                ),
              ),
            ),
          ),

          // BottomSheet ที่ครึ่งล่างของจอ
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.7, // 70% ของความสูงของหน้าจอ
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color.fromARGB(255, 26, 25,
                        25) // สีพื้นหลังของ BottomSheet ในโหมดดาร์ค
                    : Colors.white, // สีพื้นหลังของ BottomSheet ในโหมดไลท์
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // ข้อความ "เข้าสู่ระบบ" ที่มุมซ้ายบน
                    SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'ยินดีต้อนรับเข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),

                    // ฟอร์มสำหรับ "อีเมล"
                    Column(
                      children: [
                        CustomTextField(
                          labelText: 'อีเมล',
                          obscureText: false,
                          onChanged: (value) =>
                              authController.user.email.value = value,
                        ),
                        SizedBox(height: AppSpacing.md),
                        CustomTextField(
                          labelText: 'รหัสผ่าน',
                          obscureText: true,
                          onChanged: (value) =>
                              authController.user.password.value = value,
                        ),
                        SizedBox(height: AppSpacing.md),
                        // ลืมรหัสและจำรหัส
                        RememberPasswordWidget(
                          rememberPassword: _rememberPassword,
                          onRememberChanged: (value) {
                            setState(() {
                              _rememberPassword = value;
                            });
                          },
                          onForgotPassword: () {
                            Get.toNamed('/forgot-password');
                          },
                        ),
                        SizedBox(height: AppSpacing.md),
                        CustomButton(
                          text: 'เข้าสู่ระบบ',
                          onPressed: () => authController.loginwithemail(),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Ordesign(
                          text: 'หรือ',
                        ),
                        SizedBox(
                            height: AppSpacing
                                .md), // ระยะห่างระหว่าง "หรือ" กับปุ่ม social login
                        SocialLoginButtons(
                          onGooglePressed: () {
                            print("เข้าสู่ระบบด้วย Google");
                          },
                        ),
                        SizedBox(height: AppSpacing.md),
                        // ปุ่ม Create Account
                        CreateAccountButton(
                          onPressed: () => Get.toNamed('/select-create'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
