import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/getusercontroller/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constant/app.constant.dart';
import '../../../widgets/profileMenuWidget/menu_card.dart';

class HomeProfilePage extends StatefulWidget {
  @override
  _HomeProfilePageState createState() => _HomeProfilePageState();
}

class _HomeProfilePageState extends State<HomeProfilePage>
    with SingleTickerProviderStateMixin {
  String email = '';
  bool isLoggedIn = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

void _checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool rememberPassword = prefs.getBool('rememberPassword') ?? false;
  String? token = prefs.getString('token'); // ดึงจาก session

  if (token != null && token.isNotEmpty) {
    setState(() {
      isLoggedIn = true;
    });
    _loadUserInfo();
  } else {
    setState(() {
      isLoggedIn = false;
    });
  }

  // ลบข้อมูลเมื่อแอปเปิดใหม่หรือล็อกเอาท์
  if (!rememberPassword) {
    Future.delayed(Duration(seconds: 1), () async {
      await prefs.remove('token');
      await prefs.remove('email');
    });
  }
}



void _loadUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedEmail = prefs.getString('email'); //  โหลดอีเมลจาก SharedPreferences
  if (savedEmail != null && savedEmail.isNotEmpty) {
    setState(() {
      email = savedEmail;
      isLoggedIn = true;
    });
  } else {
    final authService = AuthService();
    Map<String, String> userInfo = await authService.getUserInfo();
    setState(() {
      email = userInfo['email'] ?? 'ไม่มีข้อมูล';
      isLoggedIn = true;
    });

    // บันทึก email ลง SharedPreferences เผื่อใช้ตอน rememberPassword = false
    await prefs.setString('email', email);
  }
}




void _logout() async {
  final authService = AuthService();
  await authService.clearAuth();  // ล้างข้อมูลการล็อกอิน
  setState(() {
    isLoggedIn = false;
    email = '';
  });
}
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradiant.gradientX_1,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(0, 194, 88, 88),
          body: SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.78,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromARGB(255, 26, 25, 25)
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 65),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // สำหรับกรณีที่ยังไม่ได้ล็อกอิน
                              if (!isLoggedIn) ...[
                                Text(
                                  "ยังไม่ได้ลงชื่อเข้าใช้",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => Get.toNamed('/login'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    fixedSize: Size(270, 40),
                                  ),
                                  child: Text(
                                    'ไปยังหน้าล็อกอิน',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ] else ...[
                                // กรณีที่ล็อกอินแล้ว
                                Text(
                                  "ชื่อผู้ใช้",
                                  style: TextStyle(
                                    fontSize: AppTextSize.md,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  email.isEmpty ? "กำลังโหลด..." : email,
                                  style: TextStyle(
                                    fontSize: AppTextSize.sm,
                                  ),
                                ),
                                MenuCard(
                                  title: "บัญชีและความเป็นส่วนตัว",
                                  items: [
                                    MenuItem(
                                        title: "บัญชีผู้ใช้งาน",
                                        icon: Icons.person,
                                        route: "/user-deteil"),
                                    MenuItem(
                                        title: "เปลี่ยนรหัสผ่าน",
                                        icon: Icons.lock,
                                        route: "/chang-password"),
                                    MenuItem(
                                      title: "การแจ้งเตือน",
                                      icon: Icons.notifications,
                                      route: "/notifications",
                                      isToggle: true,
                                    ),
                                  ],
                                ),
                                MenuCard(
                                  title: "อื่นๆ",
                                  items: [
                                    MenuItem(
                                        title: "ช่วยเหลือ",
                                        icon: Icons.person,
                                        route: "/profile"),
                                    MenuItem(
                                        title: "ลบบัญชีผู้ใช้",
                                        icon: Icons.person,
                                        route: "/delete-account"),
                                  ],
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _logout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD9D9D9),
                                    fixedSize: Size(350, 40),
                                  ),
                                  child: Text(
                                    'ออกจากระบบ',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -50,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 218, 165, 165),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
