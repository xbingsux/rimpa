import 'package:flutter/material.dart';
import '../../../core/constant/app.constant.dart';

import '../../../components/cards/app-card.component.dart';
import '../../../components/dropdown/app-dropdown.component.dart';
import '../../../components/imageloader/app-image.component.dart';
import '../../../core/constant/app.constant.dart';

class HomeRewardPage extends StatefulWidget {
  @override
  _HomeRewardPageState createState() => _HomeRewardPageState();
}

class _HomeRewardPageState extends State<HomeRewardPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth =
        MediaQuery.of(context).size.width; // ความกว้างของหน้าจอ
    double screenHeight =
        MediaQuery.of(context).size.height; // ความสูงของหน้าจอ
    double containerHeight = screenHeight * 0.2; // 20% ของหน้าจอ
    double boxHeight = screenHeight * 0.15; // ขนาดกล่องคะแนนเป็น 15% ของหน้าจอ

    return Scaffold(
      body: Stack(
        children: [
          // ส่วนของเนื้อหาหลัก
          Column(
            children: [
              // ส่วนหัวของหน้า (Container ที่มีพื้นหลัง gradient)
              Container(
                width: double.infinity,
                height: containerHeight, // ขนาดพื้นที่ 20% ของหน้าจอ
                decoration: BoxDecoration(
                  gradient: AppGradiant
                      .gradientY_1, // พื้นหลังใช้ gradient ตามที่คุณกำหนด
                  borderRadius: BorderRadius.only(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Stack(
                  children: [
                    // ส่วนที่เป็นพื้นหลัง (Container)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Container(), // พื้นหลังหรือสามารถใช้สีพื้นหลังที่ต้องการ
                      ),
                    ),
                    // ส่วนของ Row อยู่บนพื้นหลัง
                    Positioned(
                      top: 20, // ตั้งให้ Row อยู่บนสุด
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // ไอคอน user อยู่ในวงกลม
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.person_outline,
                                    color: Colors.black),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Username",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // ไอคอนกระดิ่งอยู่ในวงกลม
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(Icons.notifications_none,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ส่วนของกล่องคะแนน ที่ออกมาจากพื้นที่สีส่วนบน
          Positioned(
            top: containerHeight -
                boxHeight /
                    3.5, // ให้อยู่ครึ่งหนึ่งของพื้นที่ระหว่าง Container และ Expanded
            left: screenWidth / 2 -
                screenWidth *
                    0.85 /
                    2, // จัดตำแหน่งให้อยู่ตรงกลาง โดยใช้ 80% ของความกว้างหน้าจอ
            child: Container(
              width: screenWidth *
                  0.85, // กำหนดความกว้างของกล่องเป็น 80% ของความกว้างหน้าจอ
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20), // กำหนด BorderRadius 20
                color: Colors.white, // พื้นหลังของกล่อง
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ไอคอนดาวในวงกลม
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow, // สีไอคอนดาว
                    ),
                    child: Icon(Icons.star, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  // ข้อความ "คะแนน" และจำนวนคะแนน
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "คะแนน",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "100 คะแนน",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Spacer(),
                  // ไอคอนประวัติคะแนน
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10), // BorderRadius 10
                      color: Colors.blue, // สีไอคอนประวัติ
                    ),
                    child: Icon(Icons.history, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // ส่วนเนื้อหาของหน้าจอ ที่แสดงใน Expanded
          Positioned(
            top: containerHeight + boxHeight / 2, // ให้อยู่ใต้กล่องคะแนน
            left: 0,
            right: 0,
            child: Expanded(
              child: Container(
                color: Theme.of(context)
                    .scaffoldBackgroundColor, // ใช้สีพื้นหลังตามธีม
                child: Center(
                  child: Text("รีวอร์ด"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
