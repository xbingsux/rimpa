import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/shimmerloadwidget/shimmer.widget.dart';
import '../../../../widgets/loginWidget/custom_loginpage.dart';
import '../../../controllers/auth.controller.dart';
import '../../../controllers/profile/profile_controller.dart'; // นำเข้า ProfileController

class UserDetail extends StatelessWidget {
  const UserDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึง Controller
    Get.put(LoginController());
    final profileController =
        Get.put(ProfileController()); // เพิ่ม ProfileController
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// ใช้ Map เพื่อแปลงค่าจาก DB -> UI และ UI -> DB
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
    // สร้าง TextEditingController สำหรับแต่ละฟิลด์
    TextEditingController profileNameController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController birthDateController = TextEditingController();
    TextEditingController genderController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.black.withOpacity(0.8)
            : Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "บัญชีผู้ใช้",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Container(
        color: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
        child: SingleChildScrollView(
          // ใช้ SingleChildScrollView เพื่อให้เนื้อหาทั้งหมดเลื่อนลงได้
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ชื่อผู้ใช้",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (profileController.profileData["profile_name"] == null) {
                  return shimmerLoading();
                } else {
                  // ให้แสดงค่าจาก profileNameController แทนที่ค่าที่ดึงมา
                  profileNameController.text =
                      profileController.profileData["profile_name"] ?? '';
                  return Customtextprofile(
                    labelText: profileNameController.text,
                    obscureText: false,
                    controller: profileNameController,
                  );
                }
              }),
              const SizedBox(height: 18),
              const Text(
                "ชื่อ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (profileController.profileData["first_name"] == null) {
                  return shimmerLoading();
                } else {
                  firstNameController.text =
                      profileController.profileData["first_name"] ?? '';
                  return Customtextprofile(
                    labelText: firstNameController.text,
                    obscureText: false,
                    controller: firstNameController,
                  );
                }
              }),
              const SizedBox(height: 18),
              const Text(
                "นามสกุล",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (profileController.profileData["last_name"] == null) {
                  return shimmerLoading();
                } else {
                  lastNameController.text =
                      profileController.profileData["last_name"] ?? '';
                  return Customtextprofile(
                    labelText: lastNameController.text,
                    obscureText: false,
                    controller: lastNameController,
                  );
                }
              }),
              const SizedBox(height: 18),
              const Text(
                "อีเมล",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (profileController.profileData["user"]["email"] == null) {
                  return shimmerLoading();
                } else {
                  emailController.text =
                      profileController.profileData["user"]["email"] ?? '';
                  return Customtextprofile(
                    labelText: emailController.text,
                    obscureText: false,
                    controller: emailController,
                  );
                }
              }),
              const SizedBox(height: 18),
              const Text(
                "เบอร์โทรศัพท์",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (profileController.profileData["phone"] == null) {
                  return shimmerLoading();
                } else {
                  phoneController.text =
                      profileController.profileData["phone"] ?? '';
                  return CustomPhoneTextFieldProfile(
                    phoneNumber: phoneController.text,
                    controller: phoneController,
                  );
                }
              }),
              const SizedBox(height: 18),
              const Text(
                "วันเกิด",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (profileController.profileData["birth_date"] == null) {
                  return shimmerLoading(); // กรณีที่ยังไม่มีข้อมูลวันเกิด
                } else {
                  // ตรวจสอบวันเกิดจาก profileController และใช้ค่าที่ได้
                  DateTime birthDate =
                      profileController.profileData["birth_date"] != null
                          ? DateTime.parse(
                              profileController.profileData["birth_date"])
                          : DateTime.now();

                  return CustomDatePicker(
                    labelText: 'วันเกิด',
                    selectedDate: birthDate,
                    onChanged: (DateTime value) {
                      profileController.profileData["birth_date"] =
                          value.toIso8601String();
                      birthDateController.text = DateFormat('yyyy-MM-dd')
                          .format(value); // อัปเดต birthDateController.text
                    },
                  );
                }
              }),
              const SizedBox(height: 18),
              const Text(
                "เพศ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (profileController.profileData["gender"] == null) {
                  return shimmerLoading();
                } else {
                  // ดึงค่าจาก Database (เป็น ENUM)
                  String currentGender =
                      profileController.profileData["gender"] ?? 'Other';

                  // แปลงค่า ENUM เป็นภาษาไทยสำหรับแสดงผล
                  String displayGender =
                      genderMapping[currentGender] ?? 'ไม่ระบุ';

                  // อัปเดต GenderController ให้ตรงกับ UI
                  genderController.text = displayGender;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown สำหรับเลือกเพศ
                      CustomDropdown(
                        labelText: 'เพศ',
                        selectedValue: displayGender,
                        onChanged: (value) {
                          if (value != null) {
                            // แปลงค่ากลับเป็น ENUM ที่ฐานข้อมูลรองรับ
                            String newGender =
                                reverseGenderMapping[value] ?? 'Other';

                            // อัปเดต GenderController และ ProfileController
                            genderController.text = value;
                            profileController.profileData["gender"] = newGender;
                          }
                        },
                        items: ['ชาย', 'หญิง', 'ไม่ระบุ'],
                      ),

                      // Text field แสดงค่า Gender
                    ],
                  );
                }
              }),
              const SizedBox(height: 24),
              CustomButton(
                  text: 'บันทึกข้อมูลใหม่',
                  onPressed: () {
                    String selectedGender =
                        reverseGenderMapping[genderController.text] ?? 'Other';
                    Map<String, dynamic> updatedData = {
                      'profile_name': profileNameController.text,
                      'first_name': firstNameController.text,
                      'last_name': lastNameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'birth_date': birthDateController.text,
                      'gender': selectedGender,
                    };
                    print(
                        "Updated Data to send: $updatedData"); // ตรวจสอบข้อมูลที่ส่งไป
                    profileController
                        .updateProfile(updatedData)
                        .then((response) {})
                        .catchError((error) {});
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
