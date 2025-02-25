import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'home_main.dart';
import 'home_event.dart';
import 'home_qr.dart';
import 'home_reward.dart';
import 'home_profile.dart';
import '../../../core/constant/icon_navgition_constant.dart';
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
            _buildNavItem("หน้าหลัก", 0),
            _buildNavItem("กิจกรรม", 1),
            _buildQRItem(2),
            _buildNavItem("รีวอร์ด", 3),
            _buildNavItem("โปรไฟล์", 4),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false, // ปิดการปรับขนาดเมื่อ keyboard ปรากฏ
    );
  }

  BottomNavigationBarItem _buildNavItem(String label, int index) {
    bool isActive = _selectedIndex == index;

    CustomPainter painter;
    if (label == "หน้าหลัก") {
      painter = HomeIconPainter(isActive: isActive); // ส่ง isActive
    } else if (label == "กิจกรรม") {
      painter = ActivityIconPainter(isActive: isActive);
    } else if (label == "รีวอร์ด") {
      painter = RewardIconPainter(isActive: isActive);
    } else if (label == "โปรไฟล์") {
      painter = ProfileIconPainter(isActive: isActive);
    } else {
      painter = EmtyPainter(); // ให้มันไม่ทำการวาดอะไรเลยในกรณีนี้
    }

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: isActive
                ? ShaderMask(
                    shaderCallback: (bounds) => AppGradiant.gradientX_1
                        .createShader(bounds), // ใช้ gradientX_1
                    child: CustomPaint(
                      size: Size(24, 24),
                      painter: painter, // ใช้ painter ที่กำหนดไว้
                    ),
                  )
                : CustomPaint(
                    size: Size(24, 24),
                    painter: painter, // ใช้ painter ที่กำหนดไว้
                  ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: isActive
                ? ShaderMask(
                    shaderCallback: (bounds) => AppGradiant.gradientX_1
                        .createShader(bounds), // ใช้ gradientX_1
                    child: Text(
                      label,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 182, 182, 182)),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                        color: Colors.grey), // สีเทาสำหรับข้อความเมื่อไม่เลือก
                  ),
          ),
        ],
      ),
      label: "",
    );
  }
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
        child: Align(
          alignment: Alignment.center, // ทำให้ไอคอนวาดเองอยู่ตรงกลาง
          child: CustomPaint(
            size: Size(30, 30), // ขนาดของ CustomPaint
            painter: QrIconPainter(
                isActive: index == 2), // ใช้ CustomPainter ที่วาดไอคอน
          ),
        ),
      ),
    ),
    label: "",
  );
}
