import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ฟังก์ชันสำหรับดึง token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // คืนค่า token ที่เก็บไว้
  }

  // ฟังก์ชันสำหรับดึงข้อมูลผู้ใช้ (เช่น email)
Future<Map<String, String>> getUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email') ?? ''; // ถ้าไม่มี email ใน SharedPreferences ให้ใช้ค่าว่าง
  String? token = prefs.getString('token') ?? ''; // ถ้าไม่มี token ใน SharedPreferences ให้ใช้ค่าว่าง

  return {
    'email': email,
    'token': token, // เพิ่ม token ไปในข้อมูลที่คืนค่า
  };
}


  // ฟังก์ชันสำหรับตรวจสอบว่า token มีหรือไม่
Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  return token != null && token.isNotEmpty; // ตรวจสอบว่า token มีค่าหรือไม่
}


  // ฟังก์ชันสำหรับลบ token และข้อมูลผู้ใช้ (logout)
  Future<void> clearAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token'); // ลบ token
    prefs.remove('email'); // ลบ email
  }
}


