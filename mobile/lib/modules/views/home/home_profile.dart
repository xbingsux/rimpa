import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/getusercontroller/auth_service.dart';  // นำเข้า AuthService ที่คุณสร้างไว้
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/app.constant.dart';

class HomeProfilePage extends StatefulWidget {
  @override
  _HomeProfilePageState createState() => _HomeProfilePageState();
}

class _HomeProfilePageState extends State<HomeProfilePage> {
  String email = ''; // ตัวแปรสำหรับเก็บ email
  bool isLoggedIn = false; // ตัวแปรตรวจสอบสถานะล็อกอิน

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // ตรวจสอบสถานะล็อกอินเมื่อหน้าเปิด
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // ตรวจสอบค่า token
    if (token != null && token.isNotEmpty) {
      // ถ้ามี token ก็ให้โหลดข้อมูลผู้ใช้
      _loadUserInfo();
    } else {
      // ถ้าไม่มี token แสดงว่าไม่ได้ล็อกอิน
      setState(() {
        isLoggedIn = false; // ตั้งสถานะเป็นยังไม่ได้ล็อกอิน
      });
    }
  }

  void _loadUserInfo() async {
    final authService = AuthService();
    Map<String, String> userInfo = await authService.getUserInfo(); // ดึงข้อมูลผู้ใช้
    print("User Info: $userInfo"); // ตรวจสอบค่าที่ได้รับจาก SharedPreferences
    setState(() {
      email = userInfo['email'] ?? 'ไม่มีข้อมูล'; // ถ้าไม่ได้รับข้อมูลจะให้ข้อความนี้แทน
      isLoggedIn = true; // ตั้งสถานะเป็นล็อกอินแล้ว
    });
  }

  void _logout() async {
    final authService = AuthService();
    await authService.clearAuth(); // ลบข้อมูลล็อกอิน
    setState(() {
      isLoggedIn = false; // ตั้งสถานะเป็นไม่ได้ล็อกอิน
      email = ''; // เคลียร์ email
    });
  }

 @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradiant.gradientX_1, // ใช้ Gradient พื้นหลัง
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent, // พื้นหลังใส
          body: Center(
            child: isLoggedIn
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        email.isEmpty ? "กำลังโหลด..." : email,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: Text('ออกจากระบบ'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ยังไม่ได้ล็อกอิน",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Get.toNamed('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: Text('ไปยังหน้าล็อกอิน'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}