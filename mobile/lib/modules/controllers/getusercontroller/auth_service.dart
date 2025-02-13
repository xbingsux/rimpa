import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String? _token;
  String? _email;

  Future<String?> getToken() async {
    return _token;
  }

  Future<Map<String, String>> getUserInfo() async {
    return {
      'email': _email ?? '',
      'token': _token ?? '',
    };
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberPassword = prefs.getBool('rememberPassword') ?? false;
    String? token = prefs.getString('token');

    if (rememberPassword && token != null && token.isNotEmpty) {
      return true; // ผู้ใช้ล็อกอินแล้ว
    }
    return false; // ผู้ใช้ยังไม่ได้ล็อกอิน
  }

// ฟังก์ชันโหลดข้อมูลผู้ใช้งาน
  Future<String> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email ?? 'ไม่มีข้อมูล';
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberPassword = prefs.getBool('rememberPassword') ?? false;

    if (rememberPassword) {
      _token = prefs.getString('token');
      _email = prefs.getString('email');
      return (_token != null && _token!.isNotEmpty);
    }

    // ถ้าไม่ได้เลือก "จำรหัสผ่าน" ก็ตรวจสอบ token ที่เก็บไว้
    _token = prefs.getString('token');
    _email = prefs.getString('email');

    return (_token != null && _token!.isNotEmpty);
  }

  Future<void> clearAuth() async {
    _token = null;
    _email = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('rememberPassword');
  }
}
