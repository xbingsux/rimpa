import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import '../../../core/services/api_urls.dart';
import '../middleware/auth_middleware.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = <String, dynamic>{}.obs; // เปลี่ยนจาก {} เป็น Rx แบบ Map
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
    isLoading.value = true;
    try {
      String? token = await _authMiddleware.getToken();

      if (token == null) {
        isLoading.value = false;
        profileData.value = {}; // รีเซ็ตข้อมูลเมื่อไม่มี Token
        uploadStatus.value = 'ไม่สามารถดึงข้อมูลได้: ไม่มี Token';
        return;
      }
      // เปลี่ยนจากการใช้ POST เป็น GET โดยไม่ส่งข้อมูลใน body
      final response = await _getConnect.get(
        apiUrlsController.profileMe.value,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        // อัปเดต profileData ด้วยข้อมูลที่ได้จาก response
        profileData.value = response.body["profile"]; // อัปเดต Rx ของ profileData
        uploadStatus.value = ''; // รีเซ็ตสถานะการอัปโหลด
        isProfileFetched.value = true; // ตั้งสถานะว่าได้ดึงข้อมูลแล้ว
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

  Future<void> deleteUser() async {
    isLoading.value = true; // ตั้งค่าให้กำลังโหลด
    try {
      String? token = await _authMiddleware.getToken();

      if (token == null) {
        isLoading.value = false;
        uploadStatus.value = 'ไม่สามารถลบผู้ใช้ได้: ไม่มี Token';
        return;
      }

      final response = await _getConnect.post(
        apiUrlsController.deleterofileMe.value, // URL สำหรับลบผู้ใช้
        {},
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        uploadStatus.value = 'ลบผู้ใช้สำเร็จ';
        print("User deleted successfully");

        // ล้างข้อมูลใน SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // ล้างข้อมูลทั้งหมดใน SharedPreferences

        // นำทางไปยังหน้า home
        Get.offAllNamed('/home'); // ใช้ offAll เพื่อออกจากหน้าทั้งหมดและไปหน้าใหม่
      } else {
        uploadStatus.value = 'ไม่สามารถลบผู้ใช้ได้';
        print("Failed to delete user: ${response.body}");
      }
    } catch (e) {
      uploadStatus.value = 'เกิดข้อผิดพลาดในการลบผู้ใช้';
      print("Error deleting user: $e");
    } finally {
      isLoading.value = false; // ปิดสถานะโหลดเมื่อเสร็จสิ้น
      fetchProfile(); // โหลดข้อมูลโปรไฟล์ใหม่
    }
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
    if (updatedData['profile_name'] != null && updatedData['profile_name'] != profileData['profile_name']) {
      changes['profile_name'] = updatedData['profile_name'];
    }
    if (updatedData['first_name'] != null && updatedData['first_name'] != profileData['first_name']) {
      changes['first_name'] = updatedData['first_name'];
    }
    if (updatedData['last_name'] != null && updatedData['last_name'] != profileData['last_name']) {
      changes['last_name'] = updatedData['last_name'];
    }
    if (updatedData['phone'] != null && updatedData['phone'] != profileData['phone']) {
      changes['phone'] = updatedData['phone'];
    }
    if (updatedData['gender'] != null) {
      changes['gender'] = updatedData['gender'];
    }
    if (updatedData['birth_date'] != null && updatedData['birth_date'] != profileData['birth_date']) {
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

      if (response.statusCode == 201) {
              Get.back();
        // Show dialog after successful update
      } else {
        uploadStatus.value = 'อัปเดตข้อมูลล้มเหลว: ${response.statusCode}';
      }
    } catch (e) {
      uploadStatus.value = 'เกิดข้อผิดพลาดในการอัปเดตข้อมูล';
      print("Error updating profile: $e");
    } finally {
      uploadStatus.value = 'อัปเดตข้อมูลสำเร็จ';
      // Reset loading status for each field after the update
      profileNameLoading.value = false;
      firstNameLoading.value = false;
      lastNameLoading.value = false;
      emailLoading.value = false;
      phoneLoading.value = false;
      birthDateLoading.value = false;
      genderLoading.value = false;
      Get.snackbar(
        "",
        "",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: const Color(0xFF15BDFF),
        duration: const Duration(seconds: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderRadius: 12,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        titleText: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 22),
            const SizedBox(width: 10),
            Text(
              "อัปเดตข้อมูลสำเร็จ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
        messageText: const SizedBox(), // ไม่แสดงข้อความเพิ่มเติม
      );
      fetchProfile(); // โหลดข้อมูลโปรไฟล์ใหม่หลังจากการอัปเดต
      // Set shimmer animation back to true
      profileNameLoading.value = true;
      firstNameLoading.value = true;
      lastNameLoading.value = true;
      emailLoading.value = true;
      phoneLoading.value = true;
      birthDateLoading.value = true;
      genderLoading.value = true;
      isLoading.value = false;
      fetchProfile(); // โหลดข้อมูลโปรไฟล์ใหม่

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

      FormData formData = FormData({'file': MultipartFile(imageFile, filename: imageFile.path.split('/').last)});

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
      fetchProfile(); // โหลดข้อมูลโปรไฟล์ใหม่

      // ใช้ Get.snackbar แสดงข้อความ
      Get.snackbar(
        "อัปเดตข้อมูลสำเร็จ", // ข้อความหัวข้อ
        "อัปเดตข้อมูลโปรไฟล์สำเร็จ", // ข้อความเพิ่มเติม
        snackPosition: SnackPosition.BOTTOM, // แสดงที่ด้านล่างของหน้าจอ
        backgroundColor: Colors.white, // พื้นหลังของ snackbar
        colorText: Colors.blue, // สีของข้อความ
        duration: Duration(seconds: 2), // แสดงนาน 2 วินาที
        borderRadius: 12, // มุมมน
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // ระยะห่างจากขอบ
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      );
    }
  }

  @override
  void onInit() {
    fetchProfile(); // โหลดข้อมูลโปรไฟล์ทันทีเมื่อ controller เริ่มทำงาน
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

      final response = await _getConnect.get(
        apiUrlsController.profileMe.value,
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
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   fetchpoint(); // เรียกใช้ฟังก์ชัน fetchpoint ทุก ๆ 1 วินาที
    // });

    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel(); // ยกเลิก timer เมื่อ controller ปิด
    super.onClose();
  }

  void loadData() {}
}
