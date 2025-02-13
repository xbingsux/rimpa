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

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberPassword = prefs.getBool('rememberPassword') ?? false;
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (rememberPassword) {
      // เก็บ token และ email เมื่อเลือก "จำรหัสผ่าน"
      _token = prefs.getString('token');
      _email = prefs.getString('email');
    } else {
      // เก็บข้อมูลจากการล็อกอินถ้าไม่ได้เลือก "จำรหัสผ่าน"
      if (!isFirstLaunch) {
        _token = prefs.getString('token');
        _email = prefs.getString('email');
      }
    }

    // อัปเดตค่า isFirstLaunch เป็น false หลังจากเปิดแอปแล้ว
    await prefs.setBool('isFirstLaunch', false);

    return (_token != null && _token!.isNotEmpty);
  }

  Future<void> clearAuth() async {
    _token = null;
    _email = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('rememberPassword');
    await prefs.setBool('isFirstLaunch', true);
  }
}
