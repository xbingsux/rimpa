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
                    height: mediaHeight * 0.331,
                    color: AppColors.background_main,
                    child: Center(
                      child: Center(
                        child: Image.asset('assets/logoapp/logoiconic.png', width: 217, height: 132,),
                      ),
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: Offset(0, - mediaHeight * 0.03),
                child: Container(
                  width: mediaWidth,
                  constraints: BoxConstraints(
                    minHeight: mediaHeight * 0.66,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadius.lg), topRight: Radius.circular(AppRadius.lg)),
                    color: AppColors.white
                  ),
                  child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg, horizontal: AppSpacing.md),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: AppSpacing.md),
                              child: Text("ลืมรหัสผ่าน",
                                  style: TextStyle(
                                      fontSize: AppTextSize.xxl,
                                      fontWeight: FontWeight.bold,
                                      color: AppTextColors.accent2)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md),
                              child: TextField(
                                onChanged: (value) =>
                                    forgotPasswordController.email.value = value,
                                style: const TextStyle(
                                    color: AppTextColors.secondary,
                                    fontSize: AppTextSize.md),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.lg),
                                    hintText: 'อีเมล',
                                    hintStyle: const TextStyle(
                                        color: AppTextColors.secondary,
                                        fontSize: AppTextSize.md),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20),
                                        borderSide: const BorderSide(
                                            color: AppColors.secondary, width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20),
                                        borderSide: const BorderSide(
                                            color: AppColors.primary, width: 1)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20),
                                        borderSide: const BorderSide(
                                            color: AppColors.background_main,
                                            width: 1))),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: AppRadius.xs),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.toNamed('/login'),
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
                  )
                ),
              ),
            ],
          ),
        ),
      )
    );

    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       // โลโก้อยู่ตรงกลางด้านบน
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Padding(
    //           padding: EdgeInsets.only(top: screenHeight * 0.0),
    //           child: AspectRatio(
    //             aspectRatio: 4 / 3,
    //             child: Image.asset(
    //               'assets/logoapp/logoiconic.png',
    //               fit: BoxFit.contain,
    //             ),
    //           ),
    //         ),
    //       ),

    //       // ปุ่มย้อนกลับอยู่เหนือโลโก้
    //       Positioned(
    //         top: MediaQuery.of(context).padding.top + 10,
    //         left: 10,
    //         child: SafeArea(
    //           child: GestureDetector(
    //             onTap: () => Get.back(),
    //             child: Container(
    //               padding: EdgeInsets.all(10),
    //               decoration: BoxDecoration(),
    //               child: Icon(
    //                 Icons.arrow_back,
    //                 size: 18,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
          
    //       // Bottom Sheet ที่กิน 70% ของหน้าจอ
    //       Positioned(
    //         bottom: 0,
    //         left: 0,
    //         right: 0,
    //         child: Container(
    //           height: screenHeight * 0.7,
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //             color: Theme.of(context).brightness == Brightness.dark
    //                 ? Color(0xFF1E1E1E)
    //                 : Colors.white,
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(20),
    //               topRight: Radius.circular(20),
    //             ),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black.withOpacity(0.1),
    //                 blurRadius: 10,
    //                 spreadRadius: 2,
    //               ),
    //             ],
    //           ),
    //           padding: EdgeInsets.all(20),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "กู้คืนรหัสผ่าน",
    //                 style: TextStyle(
    //                   fontSize: AppTextSize.xl,
    //                   fontWeight: FontWeight.bold,
    //                   color: const Color.fromARGB(255, 16, 147, 237)
    //                 ),
    //               ),
    //               SizedBox(height: 10),
    //               Text(
    //                 "กรุณากรอกอีเมลของคุณเพื่อรับลิงก์รีเซ็ตรหัสผ่าน",
    //                 style: TextStyle(
    //                     fontSize: AppTextSize.md, color: Colors.grey[700]),
    //               ),
    //               SizedBox(height: 20),

    //               // ช่องกรอกอีเมล
    //               CustomTextField(
    //                 labelText: 'อีเมล',
    //                 obscureText: false,
    //                 onChanged: (value) =>
    //                     forgotPasswordController.email.value = value,
    //               ),
    //               SizedBox(height: 20),

    //               // ปุ่มรีเซ็ตรหัสผ่าน
    //               Obx(() {
    //                 return CustomButton(
    //                   text: forgotPasswordController.isLoading.value
    //                       ? 'กำลังส่งคำขอ...'
    //                       : 'ส่งคำขอรีเซ็ตรหัสผ่าน',
    //                   onPressed: forgotPasswordController.isLoading.value
    //                       ? () {} // ให้ปุ่มทำงานตามปกติ แต่ไม่ให้ทำการอะไร
    //                       : () {
    //                           forgotPasswordController.forgotPassword();
    //                         },
    //                 );
    //               }),

    //               // แสดงข้อความสถานะ
    //               Obx(() {
    //                 return Text(
    //                   forgotPasswordController.message.value,
    //                   style: TextStyle(
    //                     color: forgotPasswordController.status.value == 'error'
    //                         ? Colors.red
    //                         : Colors.green,
    //                   ),
    //                 );
    //               }),

    //               // ปุ่มย้อนกลับไปหน้า Login
    //               SizedBox(height: AppSpacing.md),
    //               backlogin(
    //                 onPressed: () => Get.toNamed('/login'),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
