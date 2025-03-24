import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/getusercontroller/auth_service.dart';
import 'home_main.dart';
import 'home_event.dart';
import 'home_qr.dart';
import 'home_reward.dart';
import 'home_profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  int _selectedIndex = int.tryParse(Get.parameters['pages'] ?? '0') ?? 0;
  bool isLoggedIn = false; // ตัวแปรสำหรับการตรวจสอบสถานะการล็อกอิน
  String email = ''; // ตัวแปรสำหรับเก็บข้อมูลอีเมลของผู้ใช้
  final AuthService authService = Get.find<AuthService>();
    

  @override
  void initState() {
    super.initState();
    authService.checkLoginStatusWithOutForceLogin();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // _pageController.animateToPage(
      //   _currentPage,
      //   duration: Duration(milliseconds: 300),
      //   curve: Curves.easeIn,
      // );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2 && authService.isLoggedIn.value) {
      Get.to(HomeQRPage())!.then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }else if (index == 2 && !authService.isLoggedIn.value) {
      Get.toNamed('/login')!;
    } 
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      HomeMainPage(),
      HomeEventPage(),
      HomeQRPage(),
      HomeRewardPage(),
      HomeProfilePage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        // height: 98, // ลดความสูงของ BottomNavigationBar ให้ไม่เกินไป
        child: Container(
          // color: Colors.amber,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            selectedItemColor: AppColors.primary,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.grey),
            iconSize: 24, // ปรับขนาดของไอคอนให้พอดี
            selectedFontSize: 10, // ลดขนาดตัวอักษร
            unselectedFontSize: 10, // ลดขนาดตัวอักษร
            items: [
              _buildNavItem(icon: Iconsax.home, label: "หน้าหลัก", index: 0),
              _buildNavItem(icon: Iconsax.calendar_1, label: "กิจกรรม", index: 1),
              _buildQRItem(2),
              _buildNavItem(icon: Iconsax.award, label: "รีวอร์ด", index: 3),
              _buildNavItem(icon: Iconsax.user, label: "โปรไฟล์", index: 4),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true, // ปิดการปรับขนาดเมื่อ keyboard ปรากฏ
    );
  }

  BottomNavigationBarItem _buildNavItem({required String label, required int index, required IconData icon}) {
    bool isActive = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: isActive
                ? ShaderMask(
                    shaderCallback: (bounds) => AppGradiant.gradientY_1.createShader(bounds), // ใช้ gradientX_1
                    child: CustomPaint(
                      size: Size(24, 24),
                      child: Icon(
                        icon,
                        size: 24,
                        color: Colors.white,
                      ), // ใช้ Icon แทน CustomPaint
                    ),
                  )
                : Icon(
                    icon,
                    size: 24,
                    color: Colors.grey, // Default color for inactive state
                  ),
          ),
        ],
      ),
      label: label,
    );
  }
}

BottomNavigationBarItem _buildQRItem(int index) {
  // bool isActive = (index == 2);
  return BottomNavigationBarItem(
    icon: SizedBox(
      width: 50,
      height: 50,
      child: Container(
        padding: EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: AppGradiant.gradientX_1,
        ),
        child: Align(
          alignment: Alignment.center, // ทำให้ไอคอนวาดเองอยู่ตรงกลาง
          // child: CustomPaint(
          //   size: Size(30, 30), // ขนาดของ CustomPaint
          //   painter: QrIconPainter(isActive: index == 2), // ใช้ CustomPainter ที่วาดไอคอน
          // ),

          child: CustomPaint(
            size: Size(24, 24),
            child: Icon(
              Iconsax.scan,
              size: 24,
              color: Colors.white,
            ), // ใช้ Icon แทน CustomPaint
          ),
        ),
      ),
    ),
    label: "",
  );
}
