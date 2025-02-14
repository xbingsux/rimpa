import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  RxBool isLoggedIn = false.obs; // ใช้ RxBool แทนการใช้ async
  String? _token;
  String? _email;

  Future<AuthService> init() async {
    await loadUserData();
    return this;
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _email = prefs.getString('email');
    
    // ไม่ต้องเช็คการหมดอายุจาก loginTime แล้ว เพราะจะเช็คใน checkLoginStatus()
    if (_token != null && _token!.isNotEmpty) {
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }

  bool isLoggedInSync() {
    return isLoggedIn.value; // เช็คสถานะล็อกอินแบบ Sync
  }

  Future<void> saveAuth(String token, String email, bool rememberPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('email', email);
    await prefs.setBool('rememberPassword', rememberPassword);
    await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);
    
    _token = token;
    _email = email;
    isLoggedIn.value = true;
  }

  Future<void> clearAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('rememberPassword');
    await prefs.remove('loginTime');
    
    _token = null;
    _email = null;
    isLoggedIn.value = false;
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberPassword = prefs.getBool('rememberPassword') ?? false;
    String? token = prefs.getString('token');
    int? loginTime = prefs.getInt('loginTime'); // เวลาที่ล็อกอินล่าสุด

    if (token != null && token.isNotEmpty) {
      if (!rememberPassword) {
        // ตรวจสอบว่า token หมดอายุหรือยัง (24 ชั่วโมง)
        if (loginTime != null) {
          int currentTime = DateTime.now().millisecondsSinceEpoch;
          int expiryTime = loginTime + (24 * 60 * 60 * 1000); // +24 ชั่วโมง
          if (currentTime > expiryTime) {
            await clearAuth(); // ลบ token และข้อมูลผู้ใช้
            return false;
          }
        } else {
          await clearAuth(); // ถ้าไม่มี loginTime ลบทิ้งกันพลาด
          return false;
        }
      }
      return true; // ถ้ามี token และยังไม่หมดอายุ
    }
    return false; // ไม่มี token หรือหมดอายุไปแล้ว
  }

  Future<String> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email ?? 'ไม่มีข้อมูล';
  }
}
