import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
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
  int _selectedIndex = 0;

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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        iconSize: 24, // ตั้งขนาดไอคอนให้เหมาะสม
        selectedFontSize: 12, // ขนาดฟอนต์ที่เลือก
        unselectedFontSize: 12, // ขนาดฟอนต์ที่ไม่ได้เลือก
        items: [
          _buildNavItem(Icons.home, "หน้าหลัก", 0),
          _buildNavItem(Icons.event, "กิจกรรม", 1),
          _buildQRItem(2), // ไอคอนตรงกลาง
          _buildNavItem(Icons.star, "รีวอร์ด", 3),
          _buildNavItem(Icons.person, "โปรไฟล์", 4),
        ],
      ),
    );
  }

  // **ฟังก์ชันสร้างไอคอนของ BottomNavigationBarItem**
  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กลาง
        children: [
          isActive
              ? ShaderMask(
                  shaderCallback: (bounds) =>
                      AppGradiant.gradientX_1.createShader(bounds),
                  child: Icon(icon,
                      color: Colors.white, size: 24), // เพิ่มขนาดของไอคอน
                )
              : Icon(icon, color: Colors.grey, size: 24), // เพิ่มขนาดของไอคอน
          const SizedBox(height: 4),
          isActive
              ? ShaderMask(
                  shaderCallback: (bounds) =>
                      AppGradiant.gradientX_1.createShader(bounds),
                  child: Text(
                    label,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Text(label, style: TextStyle(color: Colors.grey)),
        ],
      ),
      label: "",
    );
  }

  // **ฟังก์ชันสร้างไอคอน QR Code ตรงกลาง**
  BottomNavigationBarItem _buildQRItem(int index) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 60,
        height: 60,
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
