import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/widgets/custom_loginpage.dart'; 
import '../../../core/constant/app.constant.dart';
import '../formloginWithnumberphone/PhoneLoginForm.dart'; // ✅ นำเข้า PhoneLoginForm

class LoginSelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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

            SizedBox(height: AppSpacing.xl),

            // โลโก้ตรงกลาง
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logoapp/logoiconic.png',
                height: 120,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // หัวข้อ "เข้าสู่ระบบ" ตรงกลาง
            Text(
              'สร้างบัญชีครั้งแรก',
              style: TextStyle(fontSize: 24),
            ),

            SizedBox(height: AppSpacing.lg),

            // ปุ่มเลือกล็อกอิน
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomButton(
                    text: 'เข้าสู่ระบบด้วยอีเมล',
                    onPressed: () {
                      Get.toNamed('/create-account');
                    },
                  ),
                  SizedBox(height: AppSpacing.lg),

                  //ปุ่มเข้าสู่ระบบด้วยเบอร์โทรศัพท์ (เรียก Bottom Sheet)
                  CustomButton(
                    text: 'เข้าสู่ระบบด้วยเบอร์โทรศัพท์',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white, //  พื้นหลังสีขาว
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20), //  มุมโค้ง
                          ),
                        ),
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.6, //  ตั้งให้ Bottom Sheet อยู่กึ่งกลาง (50% ของจอ)
                            child: PhoneLoginForm(
                              phoneNumber: Get.arguments ?? '', //  รับค่าจากหน้าอื่น (ถ้ามี)
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.lg),

                  CustomButton(
                    text: 'เข้าสู่ระบบด้วย Google',
                    onPressed: () {
                      // TODO: ใส่โค้ด Google Login
                    },
                  ),
                  SizedBox(height: AppSpacing.lg),

                  CustomButton(
                    text: 'เข้าสู่ระบบด้วย Facebook',
                    onPressed: () {
                      // TODO: ใส่โค้ด Facebook Login
                    },
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  //ปุ่มสมัครสมาชิก
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
