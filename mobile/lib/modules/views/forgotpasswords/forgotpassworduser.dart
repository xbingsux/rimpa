import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/core/theme/theme_controller.dart';
import '../../../widgets/loginWidget/custom_loginpage.dart';
import '../../controllers/forgotpassword/forgotpassword.controller.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final forgotPasswordController = Get.put(ForgotPasswordController());
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // โลโก้อยู่ตรงกลางด้านบน
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.0),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  'assets/logoapp/logoiconic.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ปุ่มย้อนกลับอยู่เหนือโลโก้
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(),
                  child: Icon(
                    Icons.arrow_back,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom Sheet ที่กิน 70% ของหน้าจอ
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.7,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF1E1E1E)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "กู้คืนรหัสผ่าน",
                    style: TextStyle(
                      fontSize: AppTextSize.xl,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "กรุณากรอกอีเมลของคุณเพื่อรับลิงก์รีเซ็ตรหัสผ่าน",
                    style: TextStyle(
                        fontSize: AppTextSize.md, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),

                  // ช่องกรอกอีเมล
                  CustomTextField(
                    labelText: 'อีเมล',
                    obscureText: false,
                    onChanged: (value) =>
                        forgotPasswordController.email.value = value,
                  ),
                  SizedBox(height: 20),

                  // ปุ่มรีเซ็ตรหัสผ่าน
                  Obx(() {
                    return CustomButton(
                      text: forgotPasswordController.isLoading.value
                          ? 'กำลังส่งคำขอ...'
                          : 'ส่งคำขอรีเซ็ตรหัสผ่าน',
                      onPressed: forgotPasswordController.isLoading.value
                          ? () {} // ให้ปุ่มทำงานตามปกติ แต่ไม่ให้ทำการอะไร
                          : () {
                              forgotPasswordController.forgotPassword();
                            },
                    );
                  }),

                  // แสดงข้อความสถานะ
                  Obx(() {
                    return Text(
                      forgotPasswordController.message.value,
                      style: TextStyle(
                        color: forgotPasswordController.status.value == 'error'
                            ? Colors.red
                            : Colors.green,
                      ),
                    );
                  }),

                  // ปุ่มย้อนกลับไปหน้า Login
                  SizedBox(height: AppSpacing.md),
                  backlogin(
                    onPressed: () => Get.toNamed('/login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
