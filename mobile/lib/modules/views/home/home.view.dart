import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'home_main.dart';
import 'home_event.dart';
import 'home_qr.dart';
import 'home_reward.dart';
import 'home_profile.dart';
import '../../controllers/getusercontroller/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  int _selectedIndex = 0;
  bool isLoggedIn = false; // ตัวแปรสำหรับการตรวจสอบสถานะการล็อกอิน
  String email = ''; // ตัวแปรสำหรับเก็บข้อมูลอีเมลของผู้ใช้

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Get.to(HomeQRPage())!.then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else {
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
      body: SafeArea(
        child: _pages[_selectedIndex], // เนื้อหาหลัก
      ),
      bottomNavigationBar: Container(
        height: 98, // ลดความสูงของ BottomNavigationBar ให้ไม่เกินไป
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          iconSize: 24, // ปรับขนาดของไอคอนให้พอดี
          selectedFontSize: 10, // ลดขนาดตัวอักษร
          unselectedFontSize: 10, // ลดขนาดตัวอักษร
          items: [
            _buildNavItem(Icons.home, "หน้าหลัก", 0),
            _buildNavItem(Icons.event, "กิจกรรม", 1),
            _buildQRItem(2),
            _buildNavItem(Icons.star, "รีวอร์ด", 3),
            _buildNavItem(Icons.person, "โปรไฟล์", 4),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false, // ปิดการปรับขนาดเมื่อ keyboard ปรากฏ
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 0), // เพิ่ม padding ด้านบนให้เท่ากันทั้งสองกรณี
            child: isActive
                ? ShaderMask(
                    shaderCallback: (bounds) =>
                        AppGradiant.gradientX_1.createShader(bounds),
                    child: Icon(icon, color: Colors.white, size: 24),
                  )
                : Icon(icon, color: Colors.grey, size: 24),
          ),
          const SizedBox(height: 4), // ให้ความห่างระหว่างไอคอนกับข้อความ
          Padding(
            padding: const EdgeInsets.only(
                top: 0), // เพิ่ม padding ด้านบนให้เท่ากันทั้งสองกรณี
            child: isActive
                ? ShaderMask(
                    shaderCallback: (bounds) =>
                        AppGradiant.gradientX_1.createShader(bounds),
                    child: Text(
                      label,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(color: Colors.grey),
                  ),
          ),
        ],
      ),
      label: "",
    );
  }

  BottomNavigationBarItem _buildQRItem(int index) {
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
          child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
        ),
      ),
      label: "",
    );
  }
}
