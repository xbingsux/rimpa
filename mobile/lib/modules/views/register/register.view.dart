import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rimpa/components/dropdown/app-dropdown-v2.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/widgets/textFeild/text_form_field.dart';
import '../../controllers/register.controller.dart';

class CreateAccountView extends StatefulWidget {
  final bool isCreate;
  const CreateAccountView({super.key, this.isCreate = true});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final registerController = Get.put(RegisterController());
  Rx<TextEditingController> profileName = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> firstName = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> lastName = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> phone = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> email = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> password = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> confirmpass = Rx<TextEditingController>(TextEditingController());
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whisperGray,
          // backgroundColor: Colors.amber,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            widget.isCreate ? 'สมัครสมาชิก' : 'บัญชีผู้ใช้งาน',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: AppTextSize.xl,
                  fontWeight: FontWeight.w600,
                ),
          ),
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: const Icon(
                Icons.arrow_back,
                size: AppTextSize.xxl,
                color: AppTextColors.secondary,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RimpaTextFormField(
                    hintText: 'ชื่อผู้ใช้',
                    controller: profileName.value,
                    onChanged: (value) => registerController.profile.profileName.value = value,
                    validator: RequiredValidator(errorText: ''),
                    showTitle: true,
                  ),
                  RimpaTextFormField(
                    hintText: 'ชื่อ',
                    controller: firstName.value,
                    onChanged: (value) => registerController.profile.firstName.value = value,
                    validator: RequiredValidator(errorText: ''),
                    showTitle: true,
                  ),
                  RimpaTextFormField(
                    hintText: 'นามสกุล',
                    controller: lastName.value,
                    onChanged: (value) => registerController.profile.lastName.value = value,
                    validator: RequiredValidator(errorText: ''),
                    showTitle: true,
                  ),

                  RimpaTextFormField(
                    hintText: 'อีเมล',
                    controller: email.value,
                    onChanged: (value) => registerController.user.email.value = value,
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: ''),
                        EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                      ],
                    ),
                    showTitle: true,
                  ),
                  RimpaTextFormField(
                    hintText: 'หมายเลขโทรศัพท์',
                    controller: phone.value,
                    onChanged: (value) => registerController.profile.phone.value = value,
                    validator: MultiValidator([
                      RequiredValidator(errorText: ''),
                      PatternValidator(r'^(0[689]{1})+([0-9]{8})$', errorText: 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง'),
                    ]),
                    showTitle: true,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(8),
                      Text(
                        'วันเกิด',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: AppTextSize.md,
                              fontWeight: FontWeight.w600,
                              color: AppTextColors.secondary,
                            ),
                      ),
                      Gap(4),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await DatePicker.showSimpleDatePicker(
                            context,
                            initialDate: registerController.profile.birthDate.value,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            dateFormat: "dd-MMMM-yyyy",
                            locale: DateTimePickerLocale.th, // ✅ ตั้งค่าภาษาไทย
                            looping: false,
                            backgroundColor: Colors.white,
                            // textColor: Colors.black,
                            itemTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: AppTextSize.xl,
                                  fontWeight: FontWeight.w500,
                                  // color: AppTextColors.secondary,
                                ),
                            titleText: "กรุณาเลือกวันเกิด",
                            cancelText: "ยกเลิก",
                            confirmText: "ตกลง",
                          );
                          if (pickedDate != null) {
                            registerController.profile.birthDate.value = pickedDate;
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            hintText: 'วันเกิด',
                            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: AppTextSize.md,
                                  fontWeight: FontWeight.w600,
                                ),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.secondary, width: 1)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primary, width: 1)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.background_main, width: 1)),
                          ),
                          child: Obx(() => Text(
                                // ✅ ครอบ Text ด้วย Obx() เพื่อให้มันอัปเดตอัตโนมัติ
                                DateFormat('d MMMM yyyy', 'th').format(registerController.profile.birthDate.value),
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: AppTextSize.md,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: Text(
                            'เพศ',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: AppTextSize.md,
                                  fontWeight: FontWeight.w600,
                                  color: AppTextColors.secondary,
                                ),
                          ),
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            hintText: "เพศ",
                            hintStyle: const TextStyle(color: AppColors.secondary, fontSize: AppTextSize.md),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppColors.secondary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppColors.primary, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppColors.background_main, width: 1),
                            ),
                          ),
                          child: Obx(
                            () => AppDropdownV2Component(
                                defaultText: 'ไม่ระบุ',
                                choices: const ['ชาย', 'หญิง', 'ไม่ระบุ'],
                                selected: registerController.profile.gender.value,
                                onchanged: (value) => registerController.profile.gender.value = value),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.isCreate)
                    RimpaTextFormField(
                      hintText: 'รหัสผ่าน',
                      isPassword: true,
                      controller: password.value,
                      onChanged: (value) => registerController.user.password.value = value,
                      validator: RequiredValidator(errorText: ''),
                      showTitle: true,
                    ),
                  if (widget.isCreate)
                    RimpaTextFormField(
                      hintText: 'ยืนยันรหัสผ่าน',
                      isPassword: true,
                      controller: confirmpass.value,
                      onChanged: (value) => confirmpass.value.text = value,
                      validator: (val) {
                        return MatchValidator(errorText: 'รหัสผ่านไม่ตรงกัน').validateMatch(val!, password.value.text);
                      },
                      showTitle: true,
                    ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Padding(
                  //         padding: EdgeInsets.all(AppSpacing.sm),
                  //         child: Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary)),
                  //       ),
                  //       IntlPhoneField(
                  //         onChanged: (value) => registerController.profile.phone.value = value.completeNumber,
                  //         style: const TextStyle(color: AppTextColors.secondary, fontSize: AppTextSize.md),
                  //         decoration: InputDecoration(
                  //           contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  //           hintText: 'เบอร์โทรศัพท์',
                  //           hintStyle: const TextStyle(color: AppTextColors.secondary, fontSize: AppTextSize.md),
                  //           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.secondary, width: 1)),
                  //           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primary, width: 1)),
                  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.background_main, width: 1)),
                  //         ),
                  //         flagsButtonPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  //         flagsButtonMargin: const EdgeInsets.only(right: AppSpacing.lg),
                  //         dropdownDecoration: const BoxDecoration(border: Border(right: BorderSide(width: 1, color: AppTextColors.secondary))),
                  //         initialCountryCode: 'TH', // กำหนดประเทศเริ่มต้นเป็นประเทศไทย 🇹🇭
                  //         showCountryFlag: true, // แสดงธงชาติ
                  //         showDropdownIcon: false,
                  //         disableLengthCheck: true, // ปิดการตรวจสอบความยาวหมายเลข
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppRadius.md),
                    child: GestureDetector(
                      onTap: () {
                        formKey.currentState!.save();
                        if (formKey.currentState!.validate()) {
                          registerController.register();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppGradiant.gradientX_1,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            widget.isCreate ? "ยืนยัน" : "บันทึก",
                            style: const TextStyle(
                              fontSize: AppTextSize.md,
                              color: AppTextColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
