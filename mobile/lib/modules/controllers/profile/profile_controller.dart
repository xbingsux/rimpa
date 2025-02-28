import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:async';
import '../../../core/services/api_urls.dart';
import '../middleware/auth_middleware.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = {}.obs;
  var uploadStatus = ''.obs;
  Timer? timer;
  var isProfileFetched = false.obs; // เพิ่มตัวแปรเก็บสถานะการโหลดข้อมูล

  final apiUrlsController = Get.find<ApiUrls>();
  final GetConnect _getConnect = GetConnect();
  final AuthMiddleware _authMiddleware = Get.find<AuthMiddleware>();

  void resetProfile() {
    profileData.value = {};
    isLoading.value = false;
    uploadStatus.value = '';
  }

  // ดึงข้อมูลโปรไฟล์
  Future<void> fetchProfile() async {
    if (isProfileFetched.value) return; // ไม่โหลดข้อมูลหากข้อมูลถูกโหลดแล้ว
    isLoading.value = true;
    try {
      String? token = await _authMiddleware.getToken();

      if (token == null) {
        isLoading.value = false;
        profileData.value = {};
        uploadStatus.value = 'ไม่สามารถดึงข้อมูลได้: ไม่มี Token';
        return;
      }

      final response = await _getConnect.post(
        apiUrlsController.profileMe.value,
        {},
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        profileData.value = response.body["profile"];
        uploadStatus.value = '';
      } else {
        uploadStatus.value = 'ไม่สามารถดึงข้อมูลโปรไฟล์ได้';
      }
    } catch (e) {
      uploadStatus.value = 'เกิดข้อผิดพลาดในการดึงข้อมูล';
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void showLoadingDialog() {
    // สร้างตัวแปรที่ใช้เก็บข้อความที่จะแสดง
    var loadingText = 'L O A D I N G . . .';
    var displayText = ''.obs; // ใช้ Observable

    // แสดง Dialog
    Get.defaultDialog(
      title: "กำลังโหลด",
      middleText: displayText.value, // ใช้ค่า displayText ที่จะค่อยๆ อัพเดต
      onConfirm: () {
        // ปิด Dialog เมื่อกดปุ่มตกลง
        Get.back();
      },
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      barrierDismissible: false, // ไม่ให้ปิด Dialog ด้วยการกดนอก Dialog
    );

    // ใช้ Timer เพื่อค่อยๆ เพิ่มตัวอักษร
    int index = 0;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (index < loadingText.length) {
        displayText.value += loadingText[index];
        index++;
      } else {
        timer.cancel(); // หยุด Timer เมื่อแสดงข้อความเสร็จ
        Future.delayed(Duration(seconds: 1), () {
          Get.back(); // ปิด Dialog หลังจากข้อความเสร็จ
        });
      }
    });
  }

  /// ตัวแปร isLoading สำหรับแต่ละฟิลด์
  var profileNameLoading = false.obs;
  var firstNameLoading = false.obs;
  var lastNameLoading = false.obs;
  var emailLoading = false.obs;
  var phoneLoading = false.obs;
  var birthDateLoading = false.obs;
  var genderLoading = false.obs;

// ฟังก์ชันสำหรับอัปเดตข้อมูลโปรไฟล์
  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    if (isLoading.value) return; // ป้องกันการอัปเดตซ้ำ
    isLoading.value = true;
    uploadStatus.value = 'กำลังอัปเดตข้อมูล...';

    // Set loading status for each field
    profileNameLoading.value = true;
    firstNameLoading.value = true;
    lastNameLoading.value = true;
    emailLoading.value = true;
    phoneLoading.value = true;
    birthDateLoading.value = true;
    genderLoading.value = true;

    Map<String, dynamic> changes = {};

    // เปรียบเทียบข้อมูลที่กรอกกับข้อมูลเดิม และส่งเฉพาะที่มีการเปลี่ยนแปลง
    if (updatedData['profile_name'] != null &&
        updatedData['profile_name'] != profileData['profile_name']) {
      changes['profile_name'] = updatedData['profile_name'];
    }
    if (updatedData['first_name'] != null &&
        updatedData['first_name'] != profileData['first_name']) {
      changes['first_name'] = updatedData['first_name'];
    }
    if (updatedData['last_name'] != null &&
        updatedData['last_name'] != profileData['last_name']) {
      changes['last_name'] = updatedData['last_name'];
    }
    if (updatedData['phone'] != null &&
        updatedData['phone'] != profileData['phone']) {
      changes['phone'] = updatedData['phone'];
    }
    if (updatedData['gender'] != null) {
      changes['gender'] = updatedData['gender'];
    }
    if (updatedData['birth_date'] != null &&
        updatedData['birth_date'] != profileData['birth_date']) {
      changes['birth_date'] = updatedData['birth_date'];
    }
    if (updatedData['email'] != null) {
      changes['email'] = updatedData['email'];
    }

    // ถ้าไม่มีการเปลี่ยนแปลงข้อมูล
    if (changes.isEmpty) {
      uploadStatus.value = 'ไม่มีการเปลี่ยนแปลงข้อมูล';
      isLoading.value = false;
      return;
    }

    try {
      String? token = await _authMiddleware.getToken();

      if (token == null) {
        isLoading.value = false;
        uploadStatus.value = 'ไม่สามารถอัปเดตได้: ไม่มี Token';
        return;
      }

      final response = await _getConnect.put(
        apiUrlsController.updateprofileMe.value,
        changes,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        // Show dialog after successful update
        uploadStatus.value = 'อัปเดตข้อมูลสำเร็จ';
        fetchProfile(); // โหลดข้อมูลใหม่

        // Reset loading status for each field after the update
        profileNameLoading.value = false;
        firstNameLoading.value = false;
        lastNameLoading.value = false;
        emailLoading.value = false;
        phoneLoading.value = false;
        birthDateLoading.value = false;
        genderLoading.value = false;
        Get.snackbar(
  "อัปเดทข้อมูลสำเร็จ", 
  "",
  snackPosition: SnackPosition.TOP, // แสดงที่มุมบนของหน้าจอ
  backgroundColor: Colors.white,
  colorText: const Color.fromARGB(255, 21, 189, 255), // เปลี่ยนสีข้อความ
  duration: Duration(seconds: 3), // แสดง 3 วินาที
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ลด padding ให้น้อยลง
  titleText: Text(
    "อัปเดทข้อมูลสำเร็จ",
    style: TextStyle(
      fontSize: 14, // ขนาดตัวอักษรเล็กลง
    ),
  ),
  messageText: Container(), // เอาข้อความออกไปเพื่อให้แสดงแค่ title
);


        // Set shimmer animation back to true
        profileNameLoading.value = true;
        firstNameLoading.value = true;
        lastNameLoading.value = true;
        emailLoading.value = true;
        phoneLoading.value = true;
        birthDateLoading.value = true;
        genderLoading.value = true;
      } else {
        uploadStatus.value = 'อัปเดตข้อมูลล้มเหลว: ${response.statusCode}';
      }
    } catch (e) {
      uploadStatus.value = 'เกิดข้อผิดพลาดในการอัปเดตข้อมูล';
      print("Error updating profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ฟังก์ชันสำหรับอัปโหลดโปรไฟล์ภาพ
  Future<void> uploadProfileImage(File imageFile) async {
    isLoading.value = true;
    uploadStatus.value = 'Uploading...';
    try {
      String? token = await _authMiddleware.getToken();

      if (token == null) {
        isLoading.value = false;
        uploadStatus.value = 'Token not found';
        return;
      }

      FormData formData = FormData({
        'file':
            MultipartFile(imageFile, filename: imageFile.path.split('/').last)
      });

      final response = await _getConnect.post(
        apiUrlsController.uploadprofileuser.value,
        formData,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        uploadStatus.value = 'Upload successful';
        fetchProfile();
      } else {
        uploadStatus.value = 'Upload failed: ${response.statusCode}';
      }
    } catch (e) {
      print("Error uploading image: $e");
      uploadStatus.value = 'Upload failed';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadData() {}
}

// สำหรับดึงเฉพาะข้อมูลพอยท์
class PointsController extends GetxController {
  var isLoading = false.obs;
  var profileData = {}.obs;
  var pointsData = {}.obs;
  var uploadStatus = ''.obs;
  Timer? timer;
  var isProfileFetched = false.obs;

  final apiUrlsController = Get.find<ApiUrls>();
  final GetConnect _getConnect = GetConnect();
  final AuthMiddleware _authMiddleware = Get.find<AuthMiddleware>();

  void resetProfile() {
    profileData.value = {};
    isLoading.value = false;
    uploadStatus.value = '';
  }

  // ดึงข้อมูล point ทุก 1 วินาที
  Future<void> fetchpoint() async {
    isLoading.value = true;
    try {
      String? token = await _authMiddleware.getToken();

      if (token == null) {
        isLoading.value = false;
        pointsData.value = {};
        uploadStatus.value = 'ไม่สามารถดึงข้อมูลได้: ไม่มี Token';
        return;
      }

      final response = await _getConnect.post(
        apiUrlsController.profileMe.value,
        {},
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        pointsData.value = response.body["profile"];
        uploadStatus.value = '';
      } else {
        uploadStatus.value = 'ไม่สามารถดึงข้อมูลโปรไฟล์ได้';
      }
    } catch (e) {
      uploadStatus.value = 'เกิดข้อผิดพลาดในการดึงข้อมูล';
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // เรียกใช้ fetchProfile สำหรับดึงข้อมูลเริ่มต้น

    // เรียกใช้ fetchpoint ทุก ๆ 1 วินาที
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      fetchpoint(); // เรียกใช้ฟังก์ชัน fetchpoint ทุก ๆ 1 วินาที
    });

    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel(); // ยกเลิก timer เมื่อ controller ปิด
    super.onClose();
  }

  void loadData() {}
}
