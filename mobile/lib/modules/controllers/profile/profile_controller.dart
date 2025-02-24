import 'package:get/get.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
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
  final AuthMiddleware _authMiddleware =
      Get.find<AuthMiddleware>(); 

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
  // ดึงข้อมูลโปรไฟล์
  Future<void> fetchpoint() async {
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

  // ฟังก์ชันสำหรับอัปเดตข้อมูลโปรไฟล์
 Future<void> updateProfile(Map<String, dynamic> updatedData) async {
  if (isLoading.value) return; // ป้องกันการอัปเดตซ้ำ
  isLoading.value = true;
  uploadStatus.value = 'กำลังอัปเดตข้อมูล...';

  Map<String, dynamic> changes = {};

  // เปรียบเทียบข้อมูลที่กรอกกับข้อมูลเดิม
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
  if (updatedData['birth_date'] != null && updatedData['birth_date'] != profileData['birth_date']) {
    changes['birth_date'] = updatedData['birth_date'];
  }

  // อัปเดตข้อมูลในส่วนของ email ที่อยู่ใน user
  if (updatedData['email'] != null && updatedData['email'] != profileData['user']['email']) {
    changes['user'] = {'email': updatedData['email']};
  }

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

    print("Changes to be sent: $changes");

    final response = await _getConnect.put(
      apiUrlsController.updateprofileMe.value,
      changes,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      uploadStatus.value = 'อัปเดตข้อมูลสำเร็จ';
      fetchProfile(); // โหลดข้อมูลใหม่
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
      String? token =
          await _authMiddleware.getToken();

      if (token == null) {
        isLoading.value = false;
        uploadStatus.value = 'Token not found';
        return;
      }

      FormData formData = FormData({
        'file': MultipartFile(imageFile, filename: imageFile.path.split('/').last)
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
  final AuthMiddleware _authMiddleware =
      Get.find<AuthMiddleware>(); 

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
