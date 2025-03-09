import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static final SharedPrefService _instance = SharedPrefService._internal();
  factory SharedPrefService() => _instance;

  SharedPreferences? _prefs;

  SharedPrefService._internal();

  /// ✅ เรียกใช้ SharedPreferences ครั้งแรก
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ========================== 📌 Remember Password ========================== //
  /// ✅ บันทึกค่า Remember Password (Boolean)
  Future<void> setRememberPassword(bool value) async {
    print("set data");
    await _prefs?.setBool('remember_password', value);
  }

  /// ✅ ดึงค่า Remember Password
  bool getRememberPassword() {
    return _prefs?.getBool('remember_password') ?? false;
  }

  // ========================== 📌 บันทึก Token ========================== //
  /// ✅ บันทึกค่า Token
  Future<void> setToken(String token) async {
    await _prefs?.setString('token', token);
  }

  /// ✅ ดึงค่า Token
  String? getToken() {
    return _prefs?.getString('token');
  }

  // ========================== 📌 บันทึก Email ========================== //
  /// ✅ บันทึกค่า Email
  Future<void> setEmail(String email) async {
    await _prefs?.setString('email', email);
  }

  /// ✅ ดึงค่า Email
  String? getEmail() {
    return _prefs?.getString('email');
  }

  /// ✅ บันทึกค่า Password
  Future<void> setPassword(String value) async {
    await _prefs?.setString('password', value);
  }

  /// ✅ ดึงค่า Password
  String? getPassword() {
    return _prefs?.getString('password');
  }

  // ========================== 📌 บันทึก Username ========================== //
  /// ✅ บันทึกค่า Username
  Future<void> setUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  /// ✅ ดึงค่า Username
  String? getUsername() {
    return _prefs?.getString('username');
  }

  // ========================== 📌 บันทึก Language ========================== //
  /// ✅ บันทึกค่า Language (ภาษา)
  Future<void> setLanguage(String language) async {
    await _prefs?.setString('language', language);
  }

  /// ✅ ดึงค่า Language
  String? getLanguage() {
    return _prefs?.getString('language');
  }

  // ========================== 📌 ลบค่าแต่ละตัว ========================== //
  /// ✅ ลบค่า Remember Password
  Future<void> removeRememberPassword() async {
    await _prefs?.remove('remember_password');
  }

  /// ✅ ลบค่า Token
  Future<void> removeToken() async {
    await _prefs?.remove('token');
  }

  /// ✅ ลบค่า Email
  Future<void> removeEmail() async {
    await _prefs?.remove('email');
  }

  /// ✅ ลบค่า Email
  Future<void> removePassword() async {
    await _prefs?.remove('password');
  }

  /// ✅ ลบค่า Username
  Future<void> removeUsername() async {
    await _prefs?.remove('username');
  }

  /// ✅ ลบค่า Language
  Future<void> removeLanguage() async {
    await _prefs?.remove('language');
  }

  // ========================== 📌 ลบค่าทั้งหมด ========================== //
  /// ✅ ลบค่าทั้งหมดใน SharedPreferences
  Future<void> clear() async {
    await _prefs?.clear();
  }
}
