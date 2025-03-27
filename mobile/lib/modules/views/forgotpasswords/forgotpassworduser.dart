import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import '../../controllers/forgotpassword/forgotpassword.controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final forgotPasswordController = Get.put(ForgotPasswordController());
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double mediaHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  color: AppColors.background_main,
                  child: Center(
                    child: Center(
                      child: Image.asset(
                        'assets/logoapp/logoiconic.png',
                        width: 217,
                        height: 132,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(0, -mediaHeight * 0.03),
              child: Container(
                  width: mediaWidth,
                  // constraints: BoxConstraints(
                  //   minHeight: mediaHeight * 0.66,
                  // ),
                  decoration:
                      const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.lg), topRight: Radius.circular(AppRadius.lg)), color: AppColors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Text("ลืมรหัสผ่าน", style: TextStyle(fontSize: AppTextSize.xxl, fontWeight: FontWeight.bold, color: AppTextColors.accent2)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: TextField(
                            onChanged: (value) => forgotPasswordController.email.value = value,
                            style: const TextStyle(color: AppTextColors.secondary, fontSize: AppTextSize.md),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                                hintText: 'อีเมล',
                                hintStyle: const TextStyle(color: AppTextColors.secondary, fontSize: AppTextSize.md),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.secondary, width: 1)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primary, width: 1)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.background_main, width: 1))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppRadius.md),
                          child: Obx(() {
                            return GestureDetector(
                              onTap: forgotPasswordController.isLoading.value
                                  ? null // ปิดการกดถ้ายังโหลดอยู่
                                  : () {
                                      forgotPasswordController.forgotPassword();
                                    },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: AppGradiant.gradientX_1,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: forgotPasswordController.isLoading.value
                                      ? const CircularProgressIndicator(color: Colors.white) // แสดงโหลด
                                      : const Text(
                                          "รีเซ็ตรหัสผ่าน",
                                          style: TextStyle(
                                            fontSize: AppTextSize.md,
                                            color: AppTextColors.white,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppRadius.xs),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.offAllNamed('/login'),
                                  child: Stack(
                                    children: [
                                      const Text(
                                        'หรือเข้าสู่ระบบ',
                                        style: TextStyle(
                                          fontSize: AppTextSize.md,
                                          color: AppTextColors.accent2,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0, // ปรับค่าเป็นบวก 10 pixel เพื่อให้เส้นอยู่ต่ำกว่าข้อความ
                                        child: Container(
                                          height: 0.5,
                                          color: AppTextColors.accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    ));

    
  }
}
