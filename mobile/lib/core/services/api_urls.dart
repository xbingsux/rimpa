import 'package:get/get.dart';

class ApiUrls extends GetxController {
  // Base URL และ Upload URL ที่เป็น Observable
  var imgUrl = 'https://api-rimpa.nightbears.co'.obs;
  var baseUrl = 'https://api-rimpa.nightbears.co/auth'.obs;
  var eventsUrl = 'https://api-rimpa.nightbears.co/event'.obs;
  var rewardUrl = 'https://api-rimpa.nightbears.co/reward'.obs;

  // สร้างตัวแปร URL เป็น Observable
  var login = ''.obs;
  var register = ''.obs;
  var profileMe = ''.obs;
  var updateprofileMe = ''.obs;
  var deleterofileMe = ''.obs;
  var forgotpassworduser = ''.obs;
  var resetPassword = ''.obs;
  var uploadprofileuser = ''.obs;
  var listsbanners = ''.obs;
  var getbanner = ''.obs;
  var listsevents = ''.obs;
  var getEventDetails = ''.obs;
  var Scanevent = ''.obs;
  var checkinevent = ''.obs;
  var listsreward = ''.obs;
  var getreward = ''.obs;
  var redeemReward = ''.obs;
  var checkRewardRedemption = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateAllUrls(); // อัปเดตค่า URL ทั้งหมดเมื่อเริ่มต้น
    baseUrl.listen((_) => updateAllUrls()); // ฟังการเปลี่ยนแปลงของ baseUrl
    imgUrl.listen((_) => updateAllUrls()); // ฟังการเปลี่ยนแปลงของ baseUrl
  }

// ฟังก์ชันที่ใช้ในการสร้าง URL รูปโปรไฟล์
  String getProfileImageUrl(String imagePath) {
    return '${imgUrl.value}/$imagePath';
  }

  // ฟังก์ชันที่ใช้ในการอัปเดต
  void updateBaseUrl(String newUrl) {
    baseUrl.value = newUrl;
    imgUrl.value = newUrl.replaceAll('/auth', '/upload'); // อัปเดต imgUrl ตาม baseUrl
    updateAllUrls(); // อัปเดตค่าทั้งหมดอัตโนมัติ
  }

  // ฟังก์ชันอัปเดตค่า URL ทั้งหมดอัตโนมัติ
  void updateAllUrls() {
    login.value = '${baseUrl.value}/login';
    register.value = '${baseUrl.value}/register';
    profileMe.value = '${baseUrl.value}/profileMe';
    deleterofileMe.value = '${baseUrl.value}/delete-user';
    updateprofileMe.value = '${baseUrl.value}/updateProfileMe';
    forgotpassworduser.value = '${baseUrl.value}/forgot-password';
    resetPassword.value = '${baseUrl.value}/reset-password-user';
    uploadprofileuser.value = '${imgUrl.value}/update/profile';
    listsbanners.value = '${eventsUrl.value}/list-banner';
    listsevents.value = '${eventsUrl.value}/list-event';
    getEventDetails.value = '${eventsUrl.value}/get-event';
    Scanevent.value = '${eventsUrl.value}/checkIn';
    getbanner.value = '${eventsUrl.value}/get-banner';
    checkinevent.value = '${eventsUrl.value}/checkIn';
    listsreward.value = '${rewardUrl.value}/list-reward';
    getreward.value = '${rewardUrl.value}/get-reward';
    redeemReward.value = '${rewardUrl.value}/redeem-rewards';
    checkRewardRedemption.value = '${rewardUrl.value}/check-redeem-status';
  }
}