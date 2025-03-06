import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/modules/views/home/home.view.dart';
import 'package:rimpa/modules/views/home/home_main.dart';
import 'package:rimpa/modules/views/home/home_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/auth.controller.dart';
import '../../../core/constant/app.constant.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final authController = Get.put(LoginController());
  RxList<String> savedEmails =
      <String>[].obs; // ใช้ Obx สำหรับการอัพเดตข้อมูลแบบเรียลไทม์
  Rx<TextEditingController> emailController =
      Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> passwordController =
      Rx<TextEditingController>(TextEditingController());
  bool _rememberPassword = false;
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    loadSavedEmailAndPassword(); // โหลดข้อมูลที่บันทึกไว้ตอนเริ่มต้น
    emailController.value =
        TextEditingController(text: authController.user.email.value);
    passwordController.value =
        TextEditingController(text: authController.user.password.value);
  }

  Future<void> loadSavedEmailAndPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // โหลดค่าล่าสุด

    // หาจำนวนบัญชีทั้งหมด
    int accountCount = prefs.getInt('accountIndex') ?? 0;

    print("📌 โหลดข้อมูลจาก SharedPreferences:");

    // หากมีหลายบัญชี
    List<Map<String, String>> savedAccounts = [];

    for (int i = 0; i < accountCount; i++) {
      bool rememberPassword = prefs.getBool('rememberPassword$i') ?? false;
      String savedEmail = prefs.getString('email$i') ?? '';
      String savedPassword = prefs.getString('password$i') ?? '';

      print("🔹 บัญชีที่ ${i + 1}:");
      print("🔹 Email: $savedEmail");
      print("🔹 Password: $savedPassword");

      // บันทึกข้อมูลบัญชี
      savedAccounts.add({
        'email': savedEmail,
        'password': savedPassword,
        'rememberPassword': rememberPassword.toString(),
      });
    }

    // ถ้ามีข้อมูล ให้แสดง Dialog เลือกบัญชี
    if (accountCount > 0) {
      showEmailSelectionDialog(savedAccounts);
    }
  }

  Future<void> showEmailSelectionDialog(
      List<Map<String, String>> savedAccounts) async {
    if (savedAccounts.isNotEmpty) {
      print("🚨 Showing email selection dialog");

      // แสดง Dialog เลือกอีเมลจากบัญชีที่บันทึก
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เลือกอีเมล',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ListBody(
                children: savedAccounts.map((account) {
                  String email = account['email']!;
                  String password = account['password']!;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                  'บัญชีที่ ${savedAccounts.indexOf(account) + 1}:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('อีเมล: ',
                                  style: TextStyle(color: Colors.grey[600])),
                              Text(email,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text('รหัสผ่าน: ',
                                  style: TextStyle(color: Colors.grey[600])),
                              Text(password,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  // ลบข้อมูลจาก SharedPreferences
                                  int index = savedAccounts.indexOf(account);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('email$index');
                                  await prefs.remove('password$index');

                                  // อัพเดทข้อมูลในตัวแปร
                                  savedAccounts.remove(account);

                                  // ลด accountCount
                                  int accountCount =
                                      prefs.getInt('accountIndex') ?? 0;
                                  accountCount--;

                                  // อัพเดท accountIndex
                                  await prefs.setInt(
                                      'accountIndex', accountCount);

                                  print("🚨 Removed account: $email");

                                  // ปิด Dialog
                                  Navigator.pop(context);
                                },
                                child: Text('ล้างออก',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14)),
                              ),
                              TextButton(
                                onPressed: () {
                                  // เมื่อผู้ใช้เลือกบัญชีนี้ให้กรอกข้อมูลลงในฟอร์ม
                                  authController.user.email.value = email;
                                  authController.user.password.value = password;

                                  // อัปเดต TextEditingController
                                  emailController.value.text = email;
                                  passwordController.value.text = password;

                                  // ปิด Dialog
                                  Navigator.pop(context);
                                },
                                child: Text('เลือก',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 14)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    child: SizedBox(
                      width: 300,
                      height: 175,
                      child: Center(
                        child: AppImageComponent(
                          imageType: AppImageType.assets,
                          imageAddress: 'assets/logoapp/logoiconic.png',
                          fit: BoxFit.contain,
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => Get.offAll(HomePage()),
                    child: Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.secondary,
                        size: AppTextSize.xxl,
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
                  constraints: BoxConstraints(
                    minHeight: mediaHeight * 0.66,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.lg),
                      topRight: Radius.circular(AppRadius.lg),
                    ),
                    color: AppColors.white,
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
                          child: Text("ยินดีต้อนรับเข้าสู่ระบบ",
                              style: TextStyle(
                                  fontSize: AppTextSize.xxl,
                                  fontWeight: FontWeight.bold,
                                  color: AppTextColors.accent2)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md),
                          child: GestureDetector(
                            onTap: () {
                              // เมื่อผู้ใช้คลิกที่ช่องกรอกอีเมล ให้แสดง Dialog สำหรับเลือกอีเมล
                            },
                            child: Obx(() {
                              return TextField(
                                onChanged: (value) =>
                                    authController.user.email.value = value,
                                controller: TextEditingController(
                                    text: authController
                                        .user.email.value), // กำหนดค่าเริ่มต้น
                                style: const TextStyle(
                                  color: AppTextColors.secondary,
                                  fontSize: AppTextSize.md,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.lg),
                                  hintText: 'อีเมล',
                                  hintStyle: const TextStyle(
                                    color: AppTextColors.secondary,
                                    fontSize: AppTextSize.md,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.rounded),
                                    borderSide: const BorderSide(
                                        color: AppColors.secondary, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.rounded),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.rounded),
                                    borderSide: const BorderSide(
                                        color: AppColors.background_main,
                                        width: 1),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md),
                          child: Obx(() {
                            return TextField(
                              onChanged: (value) =>
                                  authController.user.password.value = value,
                              controller: TextEditingController(
                                  text: authController
                                      .user.password.value), // กำหนดค่าเริ่มต้น
                              obscureText: true,
                              style: const TextStyle(
                                  color: AppTextColors.secondary,
                                  fontSize: AppTextSize.md),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg),
                                hintText: 'รหัสผ่าน',
                                hintStyle: const TextStyle(
                                    color: AppTextColors.secondary,
                                    fontSize: AppTextSize.md),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.rounded),
                                    borderSide: const BorderSide(
                                        color: AppColors.secondary, width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.rounded),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.rounded),
                                    borderSide: const BorderSide(
                                        color: AppColors.background_main,
                                        width: 1)),
                              ),
                            );
                          }),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: _rememberPassword,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _rememberPassword = value ?? false;
                                        });
                                      },
                                      activeColor:
                                          AppColors.accent, // สีตอนถูกเลือก
                                      checkColor: AppColors
                                          .white, // สีของเครื่องหมายถูก
                                      side: const BorderSide(
                                          width: 2, color: AppColors.secondary),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    const Text(
                                      'จำรหัสผ่าน',
                                      style: TextStyle(
                                          fontSize: AppTextSize.md,
                                          color: AppTextColors.secondary),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed('/forgot-password'),
                                  child: Stack(
                                    children: [
                                      const Text(
                                        'ลืมรหัสผ่าน?',
                                        style: TextStyle(
                                          fontSize: AppTextSize.md,
                                          color: AppTextColors.secondary,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom:
                                            0, // ปรับค่าเป็นบวก 10 pixel เพื่อให้เส้นอยู่ต่ำกว่าข้อความ
                                        child: Container(
                                          height: 1,
                                          color: AppTextColors.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppRadius.md),
                          child: GestureDetector(
                            onTap: () => authController
                                .loginwithemail(_rememberPassword),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  gradient: AppGradiant.gradientX_1,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.rounded)),
                              child: const Center(
                                child: Text(
                                  "เข้าสู่ระบบ",
                                  style: TextStyle(
                                      fontSize: AppTextSize.md,
                                      color: AppTextColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppRadius.xs),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 1,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    'หรือ',
                                    style: TextStyle(
                                        fontSize: AppTextSize.sm,
                                        color: AppTextColors.secondary),
                                  )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 1,
                                    color: AppColors.secondary,
                                  ),
                                )
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppRadius.md),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                    width: 1, color: AppColors.accent),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.rounded)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon/login/google.png',
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text(
                                  "เข้าสู่ระบบด้วยอีเมล",
                                  style: TextStyle(
                                      fontSize: AppTextSize.md,
                                      color: AppTextColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppRadius.xs),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'ยังไม่มีบัญชี ',
                                  style: TextStyle(
                                    fontSize: AppTextSize.md,
                                    color: AppTextColors.secondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed('/select-create'),
                                  child: Stack(
                                    children: [
                                      const Text(
                                        'สมัครสมาชิก',
                                        style: TextStyle(
                                          fontSize: AppTextSize.md,
                                          color: AppTextColors.accent2,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom:
                                            0, // ปรับค่าเป็นบวก 10 pixel เพื่อให้เส้นอยู่ต่ำกว่าข้อความ
                                        child: Container(
                                          height: 0.5,
                                          color: AppTextColors.accent2,
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

    // return SafeArea(
    //   child: Scaffold(
    //     body: SingleChildScrollView(
    //       child: Stack(
    //         children: [
    //           SizedBox(
    //             width: double.infinity,
    //             height: MediaQuery.of(context).size.height,
    //           ),
    // Container(
    //   width: double.infinity,
    //   height: MediaQuery.of(context).size.height * 0.33,
    //   color: AppColors.background_main,
    //   child: Center(
    //     child: SizedBox(
    //         width: 300,
    //         height: 175,
    //         child: Center(
    //             child: AppImageComponent(
    //           imageType: AppImageType.assets,
    //           imageAddress: 'assets/logoapp/logoiconic.png',
    //           fit: BoxFit.contain,
    //           borderRadius: BorderRadius.circular(0),
    //         ))),
    //   ),
    // ),
    // Positioned(
    //   left: 0,
    //   top: 0,
    //   child: GestureDetector(
    //     child: Container(
    //       padding: const EdgeInsets.all(AppSpacing.md),
    //       decoration: const BoxDecoration(),
    //       child: const Center(
    //         child: Icon(
    //           Icons.arrow_back,
    //           color: AppColors.accent,
    //           size: AppTextSize.xxl,
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
    //           Positioned(
    //             bottom: 0,
    //             child: Container(
    //               width: MediaQuery.of(context).size.width,
    //               height: MediaQuery.of(context).size.height * 0.7,
    //               decoration: const BoxDecoration(
    //                   borderRadius: BorderRadius.only(
    //                       topLeft: Radius.circular(AppRadius.md),
    //                       topRight: Radius.circular(AppRadius.md)),
    //                   color: AppColors.white),
    // child: Padding(
    //   padding: const EdgeInsets.symmetric(
    //       vertical: AppSpacing.lg, horizontal: AppSpacing.md),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Padding(
    //         padding:
    //             EdgeInsets.symmetric(vertical: AppSpacing.md),
    //         child: Text("ยินดีต้อนรับเข้าสู่ระบบ",
    //             style: TextStyle(
    //                 fontSize: AppTextSize.xxl,
    //                 fontWeight: FontWeight.bold,
    //                 color: AppTextColors.accent2)),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(
    //             vertical: AppSpacing.md),
    //         child: TextField(
    //           onChanged: (value) =>
    //               authController.user.email.value = value,
    //           style: const TextStyle(
    //               color: AppTextColors.secondary,
    //               fontSize: AppTextSize.md),
    //           decoration: InputDecoration(
    //               contentPadding: const EdgeInsets.symmetric(
    //                   horizontal: AppSpacing.lg),
    //               hintText: 'อีเมล',
    //               hintStyle: const TextStyle(
    //                   color: AppTextColors.secondary,
    //                   fontSize: AppTextSize.md),
    //               enabledBorder: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(
    //                       AppRadius.rounded),
    //                   borderSide: const BorderSide(
    //                       color: AppColors.secondary, width: 1)),
    //               focusedBorder: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(
    //                       AppRadius.rounded),
    //                   borderSide: const BorderSide(
    //                       color: AppColors.primary, width: 1)),
    //               border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(
    //                       AppRadius.rounded),
    //                   borderSide: const BorderSide(
    //                       color: AppColors.background_main,
    //                       width: 1))),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(
    //             vertical: AppSpacing.md),
    //         child: TextField(
    //           onChanged: (value) =>
    //               authController.user.email.value = value,
    //           obscureText: true,
    //           style: const TextStyle(
    //               color: AppTextColors.secondary,
    //               fontSize: AppTextSize.md),
    //           decoration: InputDecoration(
    //               contentPadding: const EdgeInsets.symmetric(
    //                   horizontal: AppSpacing.lg),
    //               hintText: 'รหัสผ่าน',
    //               hintStyle: const TextStyle(
    //                   color: AppTextColors.secondary,
    //                   fontSize: AppTextSize.md),
    //               enabledBorder: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(
    //                       AppRadius.rounded),
    //                   borderSide: const BorderSide(
    //                       color: AppColors.secondary, width: 1)),
    //               focusedBorder: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(
    //                       AppRadius.rounded),
    //                   borderSide: const BorderSide(
    //                       color: AppColors.primary, width: 1)),
    //               border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(
    //                       AppRadius.rounded),
    //                   borderSide: const BorderSide(
    //                       color: AppColors.background_main,
    //                       width: 1))),
    //         ),
    //       ),
    //       Padding(
    //           padding: const EdgeInsets.symmetric(
    //               vertical: AppSpacing.md),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Checkbox(
    //                     value: _rememberPassword,
    //                     onChanged: (bool? value) {
    //                       setState(() {
    //                         _rememberPassword = value ?? false;
    //                       });
    //                     },
    //                     activeColor:
    //                         AppColors.accent, // สีตอนถูกเลือก
    //                     checkColor: AppColors
    //                         .white, // สีของเครื่องหมายถูก
    //                     side: const BorderSide(
    //                         width: 2, color: AppColors.secondary),
    //                   ),
    //                   const SizedBox(
    //                     width: 2,
    //                   ),
    //                   const Text(
    //                     'จำรหัสผ่าน',
    //                     style: TextStyle(
    //                         fontSize: AppTextSize.md,
    //                         color: AppTextColors.secondary),
    //                   )
    //                 ],
    //               ),
    //               Stack(
    //                 children: [
    //                   const Text(
    //                     'ลืมรหัสผ่าน?',
    //                     style: TextStyle(
    //                       fontSize: AppTextSize.md,
    //                       color: AppTextColors.secondary,
    //                     ),
    //                   ),
    //                   Positioned(
    //                     left: 0,
    //                     right: 0,
    //                     bottom:
    //                         0, // ปรับค่าเป็นบวก 10 pixel เพื่อให้เส้นอยู่ต่ำกว่าข้อความ
    //                     child: Container(
    //                       height: 1,
    //                       color: AppTextColors.secondary,
    //                     ),
    //                   ),
    //                 ],
    //               )
    //             ],
    //           )),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(
    //             vertical: AppRadius.md),
    //         child: Container(
    //           width: double.infinity,
    //           padding: const EdgeInsets.all(12),
    //           decoration: BoxDecoration(
    //               gradient: AppGradiant.gradientX_1,
    //               borderRadius:
    //                   BorderRadius.circular(AppRadius.rounded)),
    //           child: const Center(
    //             child: Text(
    //               "เข้าสู่ระบบ",
    //               style: TextStyle(
    //                   fontSize: AppTextSize.md,
    //                   color: AppTextColors.white),
    //             ),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //           padding: const EdgeInsets.symmetric(
    //               vertical: AppRadius.xs),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Expanded(
    //                 flex: 2,
    //                 child: Container(
    //                   height: 1,
    //                   color: AppColors.secondary,
    //                 ),
    //               ),
    //               const Expanded(
    //                 flex: 1,
    //                 child: Center(
    //                     child: Text(
    //                   'หรือ',
    //                   style: TextStyle(
    //                       fontSize: AppTextSize.sm,
    //                       color: AppTextColors.secondary),
    //                 )),
    //               ),
    //               Expanded(
    //                 flex: 2,
    //                 child: Container(
    //                   height: 1,
    //                   color: AppColors.secondary,
    //                 ),
    //               )
    //             ],
    //           )),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(
    //             vertical: AppRadius.md),
    //         child: Container(
    //           width: double.infinity,
    //           padding: const EdgeInsets.all(12),
    //           decoration: BoxDecoration(
    //               color: AppColors.white,
    //               border: Border.all(
    //                   width: 1, color: AppColors.accent),
    //               borderRadius:
    //                   BorderRadius.circular(AppRadius.rounded)),
    //           child: const Center(
    //             child: Text(
    //               "เข้าสู่ระบบด้วยอีเมล",
    //               style: TextStyle(
    //                   fontSize: AppTextSize.md,
    //                   color: AppTextColors.primary),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       /// **โลโก้ด้านบน**
    // AspectRatio(
    //   aspectRatio: 4 / 3, // ใช้อัตราส่วนจากอันที่สอง
    //   child: Container(
    //     decoration: const BoxDecoration(
    //       color: AppColors.light, // ใส่สีพื้นหลัง
    //     ),
    //     child: Align(
    //       alignment: Alignment.center, // จัดให้อยู่ตรงกลาง
    //       child: SizedBox(
    //         width: 200, // กำหนดขนาดรูป
    //         height: 200,
    //         child: Image.asset(
    //           'assets/logoapp/logoiconic.png', // รูปภาพของยูววว์~ 💕
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //     ),
    //   ),
    // ),

    //       /// 🔹 **Bottom Sheet ที่ยืดหยุ่นและเลื่อนได้**
    //       Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Container(
    //           height: screenHeight * 0.67,
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //             color: Theme.of(context).brightness == Brightness.dark
    //                 ? const Color(0xFF1A1919) // ดาร์คโหมด
    //                 : Colors.white, // ไลท์โหมด
    //             borderRadius: const BorderRadius.only(
    //               topLeft: Radius.circular(20),
    //               topRight: Radius.circular(20),
    //             ),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black.withOpacity(0.1),
    //                 blurRadius: 10,
    //                 spreadRadius: 2,
    //               )
    //             ],
    //           ),
    //           child: SingleChildScrollView(
    //             child: Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   /// 🔹 **ข้อความต้อนรับ**
    //                   const SizedBox(height: AppSpacing.sm),
    //                   const Text(
    //                     'ยินดีต้อนรับเข้าสู่ระบบ',
    //                     style: TextStyle(
    //                         fontSize: 24.0,
    //                         fontWeight: FontWeight.bold,
    //                         color: Color.fromARGB(255, 16, 147, 237)),
    //                   ),
    //                   const SizedBox(height: AppSpacing.md),

    //                   /// 🔹 **ฟอร์มล็อกอิน**
    //                   Column(
    //                     children: [
    //                       CustomTextField(
    //                         labelText: 'อีเมล',
    //                         obscureText: false,
    //                         onChanged: (value) =>
    //                             authController.user.email.value = value,
    //                       ),
    //                       const SizedBox(height: AppSpacing.md),

    //                       /// 🔹 **ฟิลด์รหัสผ่าน**
    //                       CustomTextFieldpassword(
    //                         labelText: 'รหัสผ่าน',
    //                         obscureText: _obscureText,
    //                         onChanged: (value) =>
    //                             authController.user.password.value = value,
    //                         suffixIcon: IconButton(
    //                           icon: Icon(_obscureText
    //                               ? Icons.visibility_off
    //                               : Icons.visibility),
    //                           onPressed: () {
    //                             setState(() {
    //                               _obscureText = !_obscureText;
    //                             });
    //                           },
    //                         ),
    //                       ),
    //                       const SizedBox(height: AppSpacing.md),

    //                       /// 🔹 **"จำรหัสผ่าน" & "ลืมรหัสผ่าน"**
    //                       RememberPasswordWidget(
    //                         rememberPassword: _rememberPassword,
    //                         onRememberChanged: (value) {
    //                           setState(() {
    //                             _rememberPassword = value;
    //                           });
    //                         },
    //                         onForgotPassword: () =>
    //                             Get.toNamed('/forgot-password'),
    //                       ),
    //                       const SizedBox(height: AppSpacing.md),

    //                       /// 🔹 **ปุ่มเข้าสู่ระบบ**
    //                       CustomButton(
    //                         text: 'เข้าสู่ระบบ',
    //                         onPressed: () => authController
    //                             .loginwithemail(_rememberPassword),
    //                       ),
    //                       const SizedBox(height: AppSpacing.md),

    //                       /// 🔹 **เส้นคั่น "หรือ"**
    //                       const Ordesign(text: 'หรือ'),
    //                       const SizedBox(height: AppSpacing.md),

    //                       /// 🔹 **ปุ่มเข้าสู่ระบบด้วย Google**
    //                       SocialLoginButtons(
    //                         onGooglePressed: () =>
    //                             print("เข้าสู่ระบบด้วย Google"),
    //                       ),
    //                       const SizedBox(height: AppSpacing.md),

    //                       /// 🔹 **ปุ่มสมัครบัญชีใหม่**
    //                       CreateAccountButton(
    //                         onPressed: () => Get.toNamed('/select-create'),
    //                       ),
    //                       SizedBox(
    //                           height: screenHeight * 0.02), // ปรับระยะห่างล่าง
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),

    //       /// 🔹 **ปุ่มเปลี่ยนธีม**
    //       // Positioned(
    //       //   top: 16,
    //       //   right: 16,
    //       //   child: IconButton(
    //       //     icon: const Icon(Icons.brightness_6),
    //       //     onPressed: () => Get.find<ThemeController>().toggleTheme(),
    //       //   ),
    //       // ),
    //     ],
    //   ),
    // );
  }
}
