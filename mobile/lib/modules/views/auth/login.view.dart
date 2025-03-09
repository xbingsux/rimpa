import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/shared_pref.dart';
import 'package:rimpa/modules/views/home/home.view.dart';
import 'package:rimpa/widgets/button/botton.dart';
import 'package:rimpa/widgets/textFeild/text_form_field.dart';
import '../../controllers/auth.controller.dart';
import '../../../core/constant/app.constant.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final authController = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();
  RxList<String> savedEmails = <String>[].obs; // ใช้ Obx สำหรับการอัพเดตข้อมูลแบบเรียลไทม์
  Rx<TextEditingController> emailController = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> passwordController = Rx<TextEditingController>(TextEditingController());
  bool _rememberPassword = false;
  @override
  void initState() {
    super.initState();
    _rememberPassword = SharedPrefService().getRememberPassword();
    emailController.value.text = SharedPrefService().getEmail() ?? "";
    passwordController.value.text = SharedPrefService().getPassword() ?? "";
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
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Text("ยินดีต้อนรับเข้าสู่ระบบ", style: TextStyle(fontSize: AppTextSize.xxl, fontWeight: FontWeight.w700, color: AppTextColors.accent2)),
                        ),
                        // แก้ไขในส่วนของ email TextField
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              RimpaTextFormField(
                                hintText: 'อีเมล',
                                controller: emailController.value,
                                onChanged: (value) => authController.user.email.value = value,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(errorText: "กรุณาป้อนอีเมล"),
                                    EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                                  ],
                                ),
                              ),
                              RimpaTextFormField(
                                isPassword: true,
                                hintText: 'รหัสผ่าน',
                                controller: passwordController.value,
                                onChanged: (value) => authController.user.password.value = value,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: _rememberPassword,
                                      onChanged: (value) {
                                        bool remember = value ?? false;
                                        if (remember) {
                                          setState(() {
                                            SharedPrefService().setRememberPassword(remember);

                                            _rememberPassword = remember;
                                          });
                                        } else {
                                          SharedPrefService().setRememberPassword(remember);
                                          SharedPrefService().removeEmail();
                                          SharedPrefService().removePassword();
                                        }
                                        setState(() {
                                          SharedPrefService().setRememberPassword(value != null ? value : false);

                                          _rememberPassword = (value ?? false);
                                        });
                                      },
                                      activeColor: AppColors.accent, // สีตอนถูกเลือก
                                      checkColor: AppColors.white, // สีของเครื่องหมายถูก
                                      side: const BorderSide(width: 2, color: AppColors.secondary),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    const Text(
                                      'จำรหัสผ่าน',
                                      style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary),
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
                                        bottom: 0, // ปรับค่าเป็นบวก 10 pixel เพื่อให้เส้นอยู่ต่ำกว่าข้อความ
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
                          padding: const EdgeInsets.symmetric(vertical: AppRadius.md),
                          child: GradiantButton(
                            text: "เข้าสู่ระบบ",
                            onTap: () async => {
                              formKey.currentState!.save(),
                              if (formKey.currentState!.validate())
                                {
                                  if (SharedPrefService().getRememberPassword())
                                    {
                                      await SharedPrefService().setEmail(emailController.value.text),
                                      await SharedPrefService().setPassword(passwordController.value.text),
                                    },
                                  authController.loginwithemail(email: emailController.value.text, password: passwordController.value.text),
                                }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppRadius.xs),
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
                                onTap: () => Get.toNamed('/create-account'),
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
                                      bottom: 0, // ปรับค่าเป็นบวก 10 pixel เพื่อให้เส้นอยู่ต่ำกว่าข้อความ
                                      child: Container(
                                        height: 0.5,
                                        color: AppTextColors.accent2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
