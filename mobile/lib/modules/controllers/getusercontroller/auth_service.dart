import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../controllers/profile/profile_controller.dart';

class AuthService extends GetxService {
  RxBool isLoggedIn = false.obs; // ใช้ RxBool แทนการใช้ async

  Future<AuthService> init() async {
    return this;
  }

  bool isLoggedInSync() {
    return isLoggedIn.value; // เช็คสถานะล็อกอินแบบ Sync
  }

  Future<void> saveAuth(String token, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    // await prefs.setString('email', email);
    await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);

    isLoggedIn.value = true;
  }

  Future<void> clearAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('loginTime');
    isLoggedIn.value = false;
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberPassword = prefs.getBool('rememberPassword') ?? false;
    String? token = prefs.getString('token');
    int? loginTime = prefs.getInt('loginTime');

    if (token != null && token.isNotEmpty) {
      if (!rememberPassword) {
        if (loginTime != null) {
          int currentTime = DateTime.now().millisecondsSinceEpoch;
          int expiryTime = loginTime + (24 * 60 * 60 * 1000); // +24 ชั่วโมง
          if (currentTime > expiryTime) {
            await clearAuth(); // ลบข้อมูลการเข้าสู่ระบบ
            return false; // ไม่อนุญาตให้เข้าใช้งาน
          }
        } else {
          await clearAuth();
          return false;
        }
      }
      isLoggedIn.value = true; // ตั้งค่าผู้ใช้เข้าสู่ระบบ
      return true;
    }

    // ไม่มี token หรือ token หมดอายุ
    isLoggedIn.value = false; // ตั้งค่าผู้ใช้ไม่เข้าสู่ระบบ

    // รีเซ็ตข้อมูลใน ProfileController
    ProfileController profileController = Get.find<ProfileController>();
    profileController.resetProfile();

    // ใช้ transition เพื่อให้การเปลี่ยนหน้าเรียบง่าย
    Get.toNamed('/login');

    return false;
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('rememberPassword');
    await prefs.remove('savedEmails');
    print("✅ ลบข้อมูลผู้ใช้เรียบร้อยแล้ว");
  }

  Future<String> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email ?? 'ไม่มีข้อมูล';
  }
}
