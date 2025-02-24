import 'package:get/get.dart';

class ApiUrls extends GetxController {
  // Base URL และ Upload URL ที่เป็น Observable
  var imgUrl = 'http://192.168.1.2:3001'.obs;
  var baseUrl = 'http://192.168.1.2:3001/auth'.obs;

  // สร้างตัวแปร URL เป็น Observable
  var login = ''.obs;
  var register = ''.obs;
  var profileMe = ''.obs;
  var updateprofileMe = ''.obs;
  var forgotpassworduser = ''.obs;
  var resetPassword = ''.obs;
  var uploadprofileuser = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateAllUrls(); // อัปเดตค่า URL ทั้งหมดเมื่อเริ่มต้น
    baseUrl.listen((_) => updateAllUrls()); // ฟังการเปลี่ยนแปลงของ baseUrl
  }

// ฟั่งชั่นนำแหน่งรูปภาพ
// ฟังก์ชันที่ใช้ในการสร้าง URL รูปโปรไฟล์
  String getProfileImageUrl(String imagePath) {
    return '${imgUrl.value}/$imagePath';
  }

  // ฟังก์ชันที่ใช้ในการอัปเดต Base URL
  void updateBaseUrl(String newUrl) {
    baseUrl.value = newUrl;
    imgUrl.value =
        newUrl.replaceAll('/auth', '/upload'); // อัปเดต imgUrl ตาม baseUrl
    updateAllUrls(); // อัปเดตค่าทั้งหมดอัตโนมัติ
  }

  // ฟังก์ชันอัปเดตค่า URL ทั้งหมดอัตโนมัติ
  void updateAllUrls() {
    login.value = '${baseUrl.value}/login';
    register.value = '${baseUrl.value}/register';
    profileMe.value = '${baseUrl.value}/profileMe';
    updateprofileMe.value = '${baseUrl.value}/updateProfileMe';
    forgotpassworduser.value = '${baseUrl.value}/forgot-password';
    resetPassword.value = '${baseUrl.value}/reset-password-user';
    uploadprofileuser.value = '${imgUrl.value}/update/profile';
  }
}
