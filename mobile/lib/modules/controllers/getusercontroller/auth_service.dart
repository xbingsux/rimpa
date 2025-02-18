import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  RxBool isLoggedIn = false.obs; // ใช้ RxBool แทนการใช้ async
  String? _token;
  String? _email;

  Future<AuthService> init() async {
    return this;
  }

  bool isLoggedInSync() {
    return isLoggedIn.value; // เช็คสถานะล็อกอินแบบ Sync
  }

  Future<void> saveAuth(
      String token, String email, bool rememberPassword) async {
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
    int? loginTime = prefs.getInt('loginTime');

    if (token != null && token.isNotEmpty) {
      if (!rememberPassword) {
        if (loginTime != null) {
          int currentTime = DateTime.now().millisecondsSinceEpoch;
          int expiryTime = loginTime + (24 * 60 * 60 * 1000); // +24 ชั่วโมง
          if (currentTime > expiryTime) {
            await clearAuth();
            return false;
          }
        } else {
          await clearAuth();
          return false;
        }
      }
      isLoggedIn.value =
          true; // ทำให้ isLoggedIn เป็น true หากมี token และยังไม่หมดอายุ
      return true;
    }
    isLoggedIn.value = false; // ถ้าไม่มี token หรือหมดอายุ
    return false;
  }

  Future<String> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email ?? 'ไม่มีข้อมูล';
  }
}
