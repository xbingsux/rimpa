import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rimpa/components/dropdown/app-dropdown-v2.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/widgets/loginWidget/custom_loginpage.dart';
import '../../controllers/register.controller.dart';

class CreateAccountView extends StatelessWidget {
  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFCFBFC),
          title: Transform.translate(
            offset: const Offset(0, -2.1),
            child: const Text('ข้อมูลส่วนตัว', style: TextStyle(fontSize: AppTextSize.xl, fontWeight: FontWeight.bold),)
          ),
          leading: GestureDetector(
            child: Container(
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: const Icon(Icons.arrow_back, size: AppTextSize.xxl, color: AppTextColors.secondary,),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:  AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Text('ชื่อผู้ใช้', style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary)),
                    ),
                    TextField(
                      style: const TextStyle(
                          color: AppTextColors.secondary,
                          fontSize: AppTextSize.md),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          hintText: 'ชื่อผู้ใช้',
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Text('ชื่อ', style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary)),
                    ),
                    TextField(
                      style: const TextStyle(
                          color: AppTextColors.secondary,
                          fontSize: AppTextSize.md),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          hintText: 'ชื่อ',
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Text('นามสกุล', style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary)),
                    ),
                    TextField(
                      style: const TextStyle(
                          color: AppTextColors.secondary,
                          fontSize: AppTextSize.md),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          hintText: 'นามสกุล',
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Text('อีเมล', style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary)),
                    ),
                    TextField(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary)),
                    ),
                    IntlPhoneField(
                      style: const TextStyle(
                          color: AppTextColors.secondary,
                          fontSize: AppTextSize.md),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          hintText: 'เบอร์โทรศัพท์',
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
                                  width: 1)),
                        ),
                      flagsButtonPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      flagsButtonMargin: EdgeInsets.only(right: AppSpacing.lg),
                      dropdownDecoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1, color: AppTextColors.secondary))
                      ),
                      initialCountryCode: 'TH', // กำหนดประเทศเริ่มต้นเป็นประเทศไทย 🇹🇭
                      showCountryFlag: true, // แสดงธงชาติ
                      showDropdownIcon: false,
                      disableLengthCheck: true, // ปิดการตรวจสอบความยาวหมายเลข
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Text('วันเกิด', style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary)),
                    ),
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
                          textColor: Colors.black,
                          itemTextStyle:
                              const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          hintText: 'วันเกิด',
                          hintStyle: const TextStyle(
                              color: AppTextColors.secondary,
                              fontSize: AppTextSize.md),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: AppColors.secondary, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: AppColors.background_main,
                                  width: 1)),
                        ),
                        child: Obx(() => Text( // ✅ ครอบ Text ด้วย Obx() เพื่อให้มันอัปเดตอัตโนมัติ
                          DateFormat('d MMMM yyyy', 'th').format(registerController.profile.birthDate.value),
                          style: const TextStyle(
                              color: AppTextColors.secondary,
                              fontSize: AppTextSize.md),
                        )),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Text('เพศ', style: TextStyle(fontSize: AppTextSize.md, color: AppTextColors.secondary)),
                    ),
                    InputDecorator(
                        decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          hintText: 'เพศ',
                          hintStyle: const TextStyle(
                              color: AppTextColors.secondary,
                              fontSize: AppTextSize.md),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: AppColors.secondary, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: AppColors.background_main,
                                  width: 1)),
                        ),
                        child: AppDropdownV2Component(choices: ['ชาย', 'หญิง'], selected: 'ชาย', onchanged: (value) => registerController.profile.gender.value = value),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // ปรับขนาดให้เต็มจอ
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ปุ่มย้อนกลับ
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, size: 20),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // หัวข้อ "ยืนยันบัญชี"
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'ยืนยันสร้างบัญชี',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ฟอร์มกรอกข้อมูล
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              labelText: 'ชื่อผู้ใช้',
                              obscureText: false,
                              onChanged: (value) => registerController
                                  .profile.profileName.value = value,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'ชื่อ',
                              obscureText: false,
                              onChanged: (value) => registerController
                                  .profile.firstName.value = value,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'นามสกุล',
                              obscureText: false,
                              onChanged: (value) => registerController
                                  .profile.lastName.value = value,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'อีเมล',
                              obscureText: false,
                              onChanged: (value) =>
                                  registerController.user.email.value = value,
                            ),
                            const SizedBox(height: 16),
                            CustomPhoneRegisTextField(
                              onChanged: (value) {
                                registerController.profile.phone.value = value;
                              },
                            ),
                            const SizedBox(height: 16),
                            Obx(() => CustomDatePicker(
                                  labelText: 'วันเกิด',
                                  selectedDate: registerController.profile
                                      .birthDate.value, // ใช้ Rx<DateTime?>
                                  onChanged: (DateTime value) {
                                    registerController.profile.birthDate.value =
                                        value;
                                  },
                                )),
                            const SizedBox(height: 16),
                            Obx(() {
                              return CustomDropdown(
                                labelText: 'เพศ',
                                selectedValue: registerController
                                        .profile.gender.value.isEmpty
                                    ? 'ไม่ระบุ'
                                    : registerController.profile.gender.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    registerController.profile.gender.value =
                                        value;
                                  }
                                },
                                items: ['ชาย', 'หญิง', 'ไม่ระบุ'],
                              );
                            }),
                            const SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'รหัสผ่าน',
                              obscureText: true,
                              onChanged: (value) => registerController
                                  .user.password.value = value,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              labelText: 'ยืนยันรหัสผ่าน',
                              obscureText: true,
                              onChanged: (value) => registerController
                                  .user.password.value = value,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(), // ดันปุ่มไปล่างสุด
                      // ปุ่มยืนยันบัญชี
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CustomButton(
                              text: 'ยืนยันบัญชี',
                              onPressed: () {
                                registerController.register();
                              },
                            ),
                            const SizedBox(height: 16),
                            Haveaccountbutton(
                              onPressed: () => Get.toNamed('/login'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
