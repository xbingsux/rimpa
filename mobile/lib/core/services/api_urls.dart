import 'package:get/get.dart';

class ApiUrls extends GetxController {
  // Base URL และ Upload URL ที่เป็น Observable
  var baseUrl = 'http://192.168.1.2:3001/auth'.obs;
  var uploadsUrl = 'http://192.168.1.2:3001/upload'.obs;

  // สร้างตัวแปร URL เป็น Observable
  var login = ''.obs;
  var register = ''.obs;
  var profileMe = ''.obs;
  var forgotpassworduser = ''.obs;
  var resetPassword = ''.obs;
  var uploadprofileuser = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateAllUrls(); // อัปเดตค่า URL ทั้งหมดเมื่อเริ่มต้น
    baseUrl.listen((_) => updateAllUrls()); // ฟังการเปลี่ยนแปลงของ baseUrl
  }

  // ฟังก์ชันที่ใช้ในการอัปเดต Base URL
  void updateBaseUrl(String newUrl) {
    baseUrl.value = newUrl;
    uploadsUrl.value = newUrl.replaceAll('/auth', '/upload'); // อัปเดต uploadsUrl ตาม baseUrl
    updateAllUrls(); // อัปเดตค่าทั้งหมดอัตโนมัติ
  }

  // ฟังก์ชันอัปเดตค่า URL ทั้งหมดอัตโนมัติ
  void updateAllUrls() {
    login.value = '${baseUrl.value}/login';
    register.value = '${baseUrl.value}/register';
    profileMe.value = '${baseUrl.value}/profileMe';
    forgotpassworduser.value = '${baseUrl.value}/forgot-password';
    resetPassword.value = '${baseUrl.value}/reset-password';
    uploadprofileuser.value = '${uploadsUrl.value}/upload/profile';
  }
}
