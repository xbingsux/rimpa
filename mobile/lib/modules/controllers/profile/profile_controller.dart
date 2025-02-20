import 'package:get/get.dart'; // ใช้ GetX สำหรับการทำงานกับ API
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // สำหรับการจัดการไฟล์
import '../../../core/services/api_urls.dart'; // นำเข้าที่เก็บ API URL
import '../middleware/auth_middleware.dart'; // นำเข้า AuthMiddleware

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = {}.obs; // ทำให้เป็น Rx เพื่อให้ข้อมูลอัพเดตใน UI
  var uploadStatus = ''.obs; // สถานะการอัปโหลด

  final apiUrlsController = Get.find<ApiUrls>(); // เรียก ApiUrls จาก GetX
  final GetConnect _getConnect = GetConnect();
  final AuthMiddleware _authMiddleware =
      Get.find<AuthMiddleware>(); // เรียกใช้ AuthMiddleware
  void resetProfile() {
    profileData.value = {}; // รีเซ็ตข้อมูลโปรไฟล์
    isLoading.value = false; // รีเซ็ตสถานะการโหลด
    uploadStatus.value = ''; // รีเซ็ตสถานะการอัปโหลด
  }

  // ดึงข้อมูลโปรไฟล์
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      String? token = await _authMiddleware.getToken();

      if (token == null) {
        isLoading.value = false;
        profileData.value = {}; // รีเซ็ตข้อมูลโปรไฟล์หากไม่มี token
        uploadStatus.value = 'ไม่สามารถดึงข้อมูลได้: ไม่มี Token';
        return;
      }
      // ทำการร้องขอข้อมูลโปรไฟล์
      final response = await _getConnect.post(
        apiUrlsController.profileMe.value,
        {},
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        profileData.value = response.body["profile"];
        uploadStatus.value = ''; // รีเซ็ตสถานะการอัปโหลดเมื่อดึงข้อมูลสำเร็จ
      } else {
        uploadStatus.value = 'ไม่สามารถดึงข้อมูลโปรไฟล์ได้';
      }
    } catch (e) {
      uploadStatus.value = 'เกิดข้อผิดพลาดในการดึงข้อมูล';
    } finally {
      isLoading.value = false;
    }
  }

  // ฟังก์ชันสำหรับอัปโหลดโปรไฟล์ภาพ
  Future<void> uploadProfileImage(File imageFile) async {
    isLoading.value = true;
    uploadStatus.value = 'Uploading...';
    try {
      String? token =
          await _authMiddleware.getToken(); // ใช้ getToken จาก AuthMiddleware

      if (token == null) {
        isLoading.value = false;
        uploadStatus.value = 'Token not found';
        return;
      }

      // สร้าง FormData สำหรับการอัปโหลดไฟล์
      FormData formData = FormData({
        'file':
            MultipartFile(imageFile, filename: imageFile.path.split('/').last)
      });

      // ใช้ GetConnect สำหรับการร้องขอ API
      final response = await _getConnect.post(
        apiUrlsController
            .uploadprofileuser.value, // ใช้ API สำหรับการอัปโหลดไฟล์
        formData,
        headers: {"Authorization": "Bearer $token"}, // ใส่ Token ใน Header
      );

      if (response.statusCode == 200) {
        uploadStatus.value = 'Upload successful';
        // ถ้าต้องการอัพเดตข้อมูลโปรไฟล์หลังจากการอัปโหลด
        fetchProfile();
      } else {
        uploadStatus.value = 'Upload failed: ${response.statusCode}';
      }
    } catch (e) {
      print("Error: $e");
      uploadStatus.value = 'Upload failed';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchProfile(); // ดึงข้อมูลโปรไฟล์เมื่อเริ่มต้น
    super.onInit();
  }
}
