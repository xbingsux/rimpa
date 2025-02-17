import 'package:get/get.dart'; // ใช้ GetX สำหรับการทำงานกับ API
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // สำหรับการจัดการไฟล์
import '../../../core/services/api_urls.dart'; // นำเข้าที่เก็บ API URL

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = {}.obs;
  var uploadStatus = ''.obs; // สถานะการอัปโหลด

  final apiUrlsController = Get.find<ApiUrls>(); // เรียก ApiUrls จาก GetX
  final GetConnect _getConnect = GetConnect();

  // ดึงข้อมูลโปรไฟล์
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token"); // ดึง token จาก SharedPreferences

      if (token == null) {
        isLoading.value = false;
        return;
      }

      // ใช้ GetConnect สำหรับการร้องขอ API
      final response = await _getConnect.post(
        apiUrlsController.profileMe, // ดึง URL จาก ApiUrls
        {},
        headers: {"Authorization": "Bearer $token"}, // ใส่ Token ใน Header
      );

      if (response.statusCode == 200) {
        profileData.value = response.body["profile"];
      } else {
        print("Failed to fetch profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ฟังก์ชันสำหรับอัปโหลดโปรไฟล์ภาพ
  Future<void> uploadProfileImage(File imageFile) async {
    isLoading.value = true;
    uploadStatus.value = 'Uploading...';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token"); // ดึง token จาก SharedPreferences

      if (token == null) {
        isLoading.value = false;
        uploadStatus.value = 'Token not found';
        return;
      }

      // สร้าง FormData สำหรับการอัปโหลดไฟล์
      FormData formData = FormData({
        'file': MultipartFile(imageFile, filename: imageFile.path.split('/').last)
      });

      // ใช้ GetConnect สำหรับการร้องขอ API
      final response = await _getConnect.post(
        apiUrlsController.uploadprofileuser, // ใช้ API สำหรับการอัปโหลดไฟล์
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
    fetchProfile();
    super.onInit();
  }
}
