import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;
  double _scale = 1.0; // ใช้เพื่อควบคุมการขยายและหดตัวของรูปภาพ

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    for (int i = 1; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      setState(() {
        _progress = i / 100;
        _scale = 1.0 + (i / 100) * 0.1; // เพิ่มขนาดของรูปภาพขณะโหลด
      });
    }
    // เมื่อโหลดเสร็จแล้วไปยังหน้าถัดไป
    // Get.off(() => NextScreen());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF1E1E1E)
          : Colors.white,
      body: Stack(
        children: [
          // วางรูปภาพตรงกลางพร้อมอนิเมชันขยาย
          Align(
            alignment: Alignment.center,
            child: AnimatedScale(
              scale: _scale, // ขยายและหดตัวตามค่า _scale
              duration: Duration(milliseconds: 200), // ระยะเวลาในการขยาย/หด
              child: Container(
                width: screenWidth * 0.15,
                height: screenWidth * 0.2 * 4 / 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon/iconsendemail/sendemail.png',
                  ),
                ),
              ),
            ),
          ),

          // เงาวงกลมคลุมหลังรูปภาพพร้อมการอนิเมชัน
          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              width: screenWidth * 0.30,
              height: screenWidth * 0.30 * 3 / 4,
              duration: Duration(milliseconds: 100), // ระยะเวลาในการอนิเมชัน
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 30, // เพิ่มความเบลอของเงา
                    spreadRadius: 10, // กระจายเงามากขึ้น
                  ),
                ],
              ),
            ),
          ),

          // ขยับแถบโหลดขึ้นมาจากขอบล่าง
          Positioned(
            bottom: screenHeight * 0.35, // เพิ่มค่าจาก bottom มาเป็น top แทน
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: Column(
              children: [
                Text(
                  'กำลังส่งลิงค์ไปยังอีเมล',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),

                // แถบ LinearProgressIndicator
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                SizedBox(height: 10),

                // แสดงเปอร์เซ็นต์
                Text(
                  '${(_progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
