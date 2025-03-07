import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rimpa/modules/views/home/home.view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/auth.controller.dart';
import '../../../core/constant/app.constant.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final authController = Get.put(LoginController());
  RxList<String> savedEmails = <String>[].obs; // ใช้ Obx สำหรับการอัพเดตข้อมูลแบบเรียลไทม์
  Rx<TextEditingController> emailController = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> passwordController = Rx<TextEditingController>(TextEditingController());
  // bool _rememberPassword = false;
  // bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    loadSavedEmailAndPassword(); // โหลดข้อมูลที่บันทึกไว้ตอนเริ่มต้น
    emailController.value = TextEditingController(text: authController.user.email.value);
    passwordController.value = TextEditingController(text: authController.user.password.value);
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

  Future<void> showEmailSelectionDialog(List<Map<String, String>> savedAccounts) async {
    if (savedAccounts.isNotEmpty) {
      print("🚨 Showing email selection dialog");

      // แสดง Dialog เลือกอีเมลจากบัญชีที่บันทึก
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เลือกอีเมล', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ListBody(
                children: savedAccounts.map((account) {
                  String email = account['email']!;
                  String password = account['password']!;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('บัญชีที่ ${savedAccounts.indexOf(account) + 1}:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('อีเมล: ', style: TextStyle(color: Colors.grey[600])),
                              Text(email, style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text('รหัสผ่าน: ', style: TextStyle(color: Colors.grey[600])),
                              Text(password, style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('email$index');
                                  await prefs.remove('password$index');

                                  // อัพเดทข้อมูลในตัวแปร
                                  savedAccounts.remove(account);

                                  // ลด accountCount
                                  int accountCount = prefs.getInt('accountIndex') ?? 0;
                                  accountCount--;

                                  // อัพเดท accountIndex
                                  await prefs.setInt('accountIndex', accountCount);

                                  print("🚨 Removed account: $email");

                                  // ปิด Dialog
                                  Navigator.pop(context);
                                },
                                child: Text('ล้างออก', style: TextStyle(color: Colors.red, fontSize: 14)),
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
                                child: Text('เลือก', style: TextStyle(color: Colors.blue, fontSize: 14)),
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
    emailController.value = TextEditingController(text: authController.user.email.value);
    passwordController.value = TextEditingController(text: authController.user.password.value);
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
                        child: Image.asset(
                          'assets/logoapp/logoiconic.png',
                          width: 217,
                          height: 132,
                        ),
                        // child: AppImageComponent(
                        //   imageType: AppImageType.assets,
                        //   imageAddress: 'assets/logoapp/logoiconic.png',
                        //   fit: BoxFit.contain,
                        //   borderRadius: BorderRadius.circular(0),
                        // ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: GestureDetector(
                        onTap: () => Get.offAll(HomePage()),
                        child: Container(
                          decoration: const BoxDecoration(),
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 109, 109, 109),
                            size: AppTextSize.xxl,
                          ),
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
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Text("ยินดีต้อนรับเข้าสู่ระบบ", style: TextStyle(fontSize: AppTextSize.xxl, fontWeight: FontWeight.bold, color: AppTextColors.accent2)),
                        ),
                        // แก้ไขในส่วนของ email TextField
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: GestureDetector(onTap: () {
                            // เมื่อผู้ใช้คลิกที่ช่องกรอกอีเมล ให้แสดง Dialog สำหรับเลือกอีเมล
                          }, child: Obx(() {
                            return TextField(
                              onChanged: (value) => authController.user.email.value = value, // อัพเดตค่า email
                              controller: emailController.value, // ใช้ emailController ที่ได้ตั้งไว้
                              style: const TextStyle(
                                color: AppTextColors.secondary,
                                fontSize: AppTextSize.md,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                                  hintText: 'อีเมล',
                                  hintStyle: const TextStyle(color: AppTextColors.secondary, fontSize: AppTextSize.md),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.secondary, width: 1)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primary, width: 1)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.background_main, width: 1))),
                            );
                          })),
                        ),
                        //                           Padding(
                        //                             padding: const EdgeInsets.symmetric(
                        //                                 vertical: AppSpacing.md),
                        //                             child: Stack(
                        //                               alignment: Alignment.centerRight,
                        //                               children: [
                        //                                 TextField(
                        //                                   onChanged: (value) =>
                        //                                       authController.user.password.value = value,
                        //                                   obscureText: _obscureText,
                        //                                   style: const TextStyle(
                        //                                       color: AppTextColors.secondary,
                        //                                       fontSize: AppTextSize.md),
                        //                                   decoration: InputDecoration(
                        //                                       contentPadding: const EdgeInsets.symmetric(
                        //                                           horizontal: AppSpacing.lg),
                        //                                       hintText: 'รหัสผ่าน',
                        //                                       hintStyle: const TextStyle(
                        //                                           color: AppTextColors.secondary,
                        //                                           fontSize: AppTextSize.md),
                        //                                       enabledBorder: OutlineInputBorder(
                        //                                           borderRadius: BorderRadius.circular(
                        //                                               20),
                        //                                           borderSide: const BorderSide(
                        //                                               color: AppColors.secondary, width: 1)),
                        //                                       focusedBorder: OutlineInputBorder(
                        //                                           borderRadius: BorderRadius.circular(
                        //                                               20),
                        //                                           borderSide: const BorderSide(
                        //                                               color: AppColors.primary, width: 1)),
                        //                                       border: OutlineInputBorder(
                        //                                           borderRadius: BorderRadius.circular(
                        //                                               20),
                        //                                           borderSide: const BorderSide(
                        //                                               color: AppColors.background_main,
                        //                                               width: 1))),
                        //                                 ),
                        //                                 GestureDetector(
                        //                                   onTap: () => setState(() {
                        //                                     _obscureText = !_obscureText;
                        //                                   }),
                        //                                   child: Container(
                        //                                     decoration: const BoxDecoration(),
                        //                                     padding: const EdgeInsets.only(right: AppRadius.sm),
                        //                                     child: Icon(
                        //                                       _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        //                                       size: AppTextSize.xxl,
                        //                                       color: AppTextColors.secondary,
                        //                                     ),
                        //                                   ),
                        //                                 )
                        //                               ],
                        //                             ),
                        //                           ),
                        //                           Padding(
                        //                             padding: const EdgeInsets.symmetric(
                        //                                 vertical: AppSpacing.md),
                        //                             child: Row(
                        //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                               crossAxisAlignment: CrossAxisAlignment.center,
                        //                               children: [
                        //                                 Row(
                        //                                   crossAxisAlignment: CrossAxisAlignment.center,
                        //                                   children: [
                        //                                     Checkbox(
                        //                                       value: _rememberPassword,
                        //                                       onChanged: (bool? value) {
                        //                                         setState(() {
                        //                                           _rememberPassword = value ?? false;
                        //                                         });
                        //                                       },
                        //                                       activeColor:
                        //                                           AppColors.accent, // สีตอนถูกเลือก
                        //                                       checkColor: AppColors
                        //                                           .white, // สีของเครื่องหมายถูก
                        //                                       side: const BorderSide(
                        //                                           width: 2, color: AppColors.secondary),
                        //                                     ),
                        //                                     const SizedBox(
                        //                                       width: 2,
                        //                                     ),
                        //                                     const Text(
                        //                                       'จำรหัสผ่าน',
                        //                                       style: TextStyle(
                        //                                           fontSize: AppTextSize.md,
                        //                                           color: AppTextColors.secondary),
                        //                                     )
                        //                                   ],
                        //                                 ),
                        //                                 GestureDetector(
                        //                                   onTap: () => Get.toNamed('/forgot-password'),
                        //                                   child: Stack(
                        //                                     children: [
                        //                                       const Text(
                        //                                         'ลืมรหัสผ่าน?',
                        //                                         style: TextStyle(
                        //                                           fontSize: AppTextSize.md,
                        //                                           color: AppTextColors.secondary,
                        //                                         ),
                        //                                       ),
                        //                                       Positioned(
                        //                                         left: 0,
                        //                                         right: 0,
                        //                                         bottom:
                        //                                             0, // ปรับค่าเป็นบวก 10 pixel เพื่อให้เส้นอยู่ต่ำกว่าข้อความ
                        //                                         child: Container(
                        //                                           height: 1,
                        //                                           color: AppTextColors.secondary,
                        //                                         ),
                        //                                       ),
                        //                                     ],
                        //                                   ),
                        //                                 )
                        //                               ],
                        //                             )),
                        //                         Padding(
                        //                           padding: const EdgeInsets.symmetric(
                        //                               vertical: AppRadius.md),
                        //                           child: GestureDetector(
                        //                             onTap: () => authController.loginwithemail(_rememberPassword),
                        //                             child: Container(
                        //                               width: double.infinity,
                        //                               padding: const EdgeInsets.all(12),
                        //                               decoration: BoxDecoration(
                        //                                   gradient: AppGradiant.gradientX_1,
                        //                                   borderRadius:
                        //                                       BorderRadius.circular(20)),
                        //                               child: const Center(
                        //                                 child: Text(
                        //                                   "เข้าสู่ระบบ",
                        //                                   style: TextStyle(
                        //                                       fontSize: AppTextSize.md,
                        //                                       color: AppTextColors.white),
                        //                                 ),
                        //                               ),
                        //                             );
                        //                           }),
                        //                         ),
                        //                         Padding(
                        //                           padding: const EdgeInsets.symmetric(
                        //                               vertical: AppRadius.xs),
                        //                           child: Row(
                        //                             mainAxisAlignment: MainAxisAlignment.center,
                        //                             children: [
                        //                               const Text(
                        //                                 'ยังไม่มีบัญชี ',
                        //                                 style: TextStyle(
                        //                                   fontSize: AppTextSize.md,
                        //                                   color: AppTextColors.secondary,
                        //                                 ),
                        //                               ),
                        //                               GestureDetector(
                        //                                 onTap: () => Get.toNamed('/create-account'),
                        //                                 child: Stack(
                        //                                   children: [
                        //                                     const Text(
                        //                                       'สมัครสมาชิก',
                        //                                       style: TextStyle(
                        //                                         fontSize: AppTextSize.md,
                        //                                         color: AppTextColors.accent2,
                        //                                       ),
                        //                                     ),
                        //                                     Positioned(
                        //                                       left: 0,
                        //                                       right: 0,
                        //                                       bottom:
                        //                                           0, // ปรับค่าเป็นบวก 10 pixel เพื่อให้เส้นอยู่ต่ำกว่าข้อความ
                        //                                       child: Container(
                        //                                         height: 0.5,
                        //                                         color: AppTextColors.accent2,
                        //                                       ),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                             ],
                        //                           )),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
