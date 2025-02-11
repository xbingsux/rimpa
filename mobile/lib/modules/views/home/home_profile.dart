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
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      _loadUserInfo();
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  void _loadUserInfo() async {
    final authService = AuthService();
    Map<String, String> userInfo = await authService.getUserInfo();
    setState(() {
      email = userInfo['email'] ?? 'ไม่มีข้อมูล';
      isLoggedIn = true;
    });
  }

  void _logout() async {
    final authService = AuthService();
    await authService.clearAuth();
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
                  // BottomSheet with adjusted position
                  SingleChildScrollView(
                    // Wrap with SingleChildScrollView
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
                        padding: const EdgeInsets.only(
                            top: 65), // No padding at the top
                        child: Center(
                          child: isLoggedIn
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start, // Move to top
                                  children: [
                                    // User name (Bold and not too big)
                                    Text(
                                      "ชื่อผู้ใช้", // เปลี่ยนเป็นชื่อผู้ใช้จริงได้
                                      style: TextStyle(
                                        fontSize: AppTextSize
                                            .md, // ขนาดตัวอักษรไม่ใหญ่เกินไป
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    // Email
                                    Text(
                                      email.isEmpty ? "กำลังโหลด..." : email,
                                      style: TextStyle(
                                        fontSize: AppTextSize
                                            .sm, // ขนาดตัวอักษรเล็กลง
                                      ),
                                    ),

                                    /// เมนูบัญชีผู้ใช้
                                    MenuCard(
                                      title: "บัญซีและความเป็นส่วนตัว",
                                      items: [
                                        MenuItem(
                                            title: "บัญซีผู้ใช้งาน",
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
                                          isToggle: true, // ตั้งค่าเป็น Toggle
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
                                            title: "ลบบัญซีผู้ใช้",
                                            icon: Icons.person,
                                            route: "/Deleteaccount"),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // Logout button
                                    ElevatedButton(
                                      onPressed: _logout,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFD9D9D9),
                                        fixedSize: Size(
                                            350, 40), // กำหนดขนาดปุ่มให้แน่นอน
                                      ),
                                      child: Text('ออกจากระบบ'),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start, // Move to top
                                  children: [
                                    Text(
                                      "ยังไม่ได้ล็อกอิน",
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
                                        fixedSize: Size(
                                            270, 40), // กำหนดขนาดปุ่มให้แน่นอน
                                      ),
                                      child: Text('ไปยังหน้าล็อกอิน'),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),

                  // Profile Circle Positioned at the top
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
