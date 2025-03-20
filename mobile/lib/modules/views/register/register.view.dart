import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rimpa/components/dropdown/app-dropdown-v2.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/profile/profile_controller.dart';
import 'package:rimpa/widgets/textFeild/text_form_field.dart';
import '../../controllers/register.controller.dart';

class CreateAccountView extends StatefulWidget {
  final bool isCreate;
  const CreateAccountView({super.key, this.isCreate = true});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  Map<String, String> genderMapping = {
    'Male': 'ชาย',
    'Female': 'หญิง',
    'Other': 'ไม่ระบุ',
  };

  Map<String, String> reverseGenderMapping = {
    'ชาย': 'Male',
    'หญิง': 'Female',
    'ไม่ระบุ': 'Other',
  };

  final registerController = Get.put(RegisterController());
  final ProfileController profileController = Get.put(ProfileController());
  Rx<TextEditingController> profileName = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> firstName = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> lastName = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> phone = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> email = Rx<TextEditingController>(TextEditingController());
  Rx<String> birthDate = ''.obs;
  Rx<String> gender = ''.obs;
  Rx<TextEditingController> password = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> confirmpass = Rx<TextEditingController>(TextEditingController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    if (!widget.isCreate) {
      birthDate.value = profileController.profileData['birth_date'];
      gender.value = profileController.profileData['gender'];
      profileName.value = TextEditingController(text: profileController.profileData['profile_name']);
      firstName.value = TextEditingController(text: profileController.profileData['first_name']);
      lastName.value = TextEditingController(text: profileController.profileData['last_name']);
      phone.value = TextEditingController(text: profileController.profileData['phone']);
      email.value = TextEditingController(text: profileController.profileData['user']['email']);
    }

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
                children: [RimpaTextFormField(
                    hintText: 'อีเมล',
                    controller: email.value,
                    onChanged: (value) {
                      if(widget.isCreate) {
                        registerController.user.email.value = value;
                      }
                    },
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: ''),
                        EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                      ],
                    ),
                    showTitle: true,
                    enabled: widget.isCreate,
                  ),
                  RimpaTextFormField(
                    hintText: 'ชื่อผู้ใช้',
                    controller: profileName.value,
                    onChanged: (value) {
                      if (widget.isCreate) {
                        registerController.profile.profileName.value = value;
                      }
                    },
                    validator: RequiredValidator(errorText: ''),
                    showTitle: true,
                  ),
                  RimpaTextFormField(
                    hintText: 'ชื่อ',
                    controller: firstName.value,
                    onChanged: (value) {
                      if (widget.isCreate) {
                        registerController.profile.firstName.value = value;
                      }
                    },
                    validator: RequiredValidator(errorText: ''),
                    showTitle: true,
                  ),
                  RimpaTextFormField(
                    hintText: 'นามสกุล',
                    controller: lastName.value,
                    onChanged: (value) {
                      if(widget.isCreate) {
                        registerController.profile.lastName.value = value;
                      }
                    },
                    validator: RequiredValidator(errorText: ''),
                    showTitle: true,
                  ),

                  
                  RimpaTextFormField(
                    hintText: 'หมายเลขโทรศัพท์',
                    controller: phone.value,
                    onChanged: (value) {
                      if (widget.isCreate) {
                        registerController.profile.phone.value = value;
                      }
                    },
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
                            initialDate: widget.isCreate ?
                              registerController.profile.birthDate.value :
                              profileController.profileData['birth_date'] is DateTime ? profileController.profileData['birth_date'] : DateTime.parse(profileController.profileData['birth_date']),
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
                            if (widget.isCreate) {
                              registerController.profile.birthDate.value = pickedDate;
                            } else {
                              birthDate.value = pickedDate.toIso8601String();
                            }
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
                                widget.isCreate?
                                  DateFormat('d MMMM yyyy', 'th').format(registerController.profile.birthDate.value) :
                                  DateFormat('d MMMM yyyy', 'th').format(DateTime.parse(birthDate.value)),
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
                                defaultText: widget.isCreate ? 'ไม่ระบุ' : genderMapping[gender.value].toString(),
                                choices: const ['ชาย', 'หญิง', 'ไม่ระบุ'],
                                selected: widget.isCreate ? registerController.profile.gender.value : genderMapping[gender.value].toString(),
                                onchanged: (value) {
                                  if (widget.isCreate) {
                                    registerController.profile.gender.value = value;
                                  } else {
                                    gender.value = reverseGenderMapping[value].toString();
                                  }
                                }),
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
                      // onChanged: (value) => confirmpass.value.text = value,
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
                          if (widget.isCreate) {
                            registerController.register();
                          } else {
                            Map<String, dynamic> updatedData = {
                              'profile_name': profileName.value.text,
                              'first_name': firstName.value.text,
                              'last_name': lastName.value.text,
                              'email': email.value.text,
                              'phone': phone.value.text,
                              'birth_date': DateFormat('yyyy-MM-dd').format(DateTime.parse(birthDate.value)),
                              'gender': gender.value,
                            };
                            profileController.updateProfile(updatedData).then((response) {}).catchError((error) {});
                          }
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
