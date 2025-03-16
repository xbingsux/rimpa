import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/profile/profile_controller.dart';
import 'package:rimpa/modules/views/history/history.view.dart';

class RewardScore extends StatelessWidget {
  const RewardScore({super.key});

  @override
  Widget build(BuildContext context) {
    final pointsController = Get.put(PointsController());
    pointsController.fetchpoint();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Container(
        // width: 350,
        height: 84,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // เปลี่ยนสีพื้นหลังตามธีม
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max, // ใช้พื้นที่เต็ม
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // เว้นระยะระหว่าง elements
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: AppGradiant.gradientX_1, // Applied gradient
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "คะเเนน",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Obx(() {
                      // ดึงค่าคะแนนจาก profileData
                      
                      var points = pointsController.pointsData["points"];
                      double? pointsValue = double.tryParse(points.toString());

                      // ถ้าคะแนนผิดพลาดหรือน้อยกว่าหรือเท่ากับ 0 ให้แสดง "0"
                      String displayPoints = (pointsValue == null || pointsValue <= 0)
                          ? "0"
                          : (pointsValue > 999999)
                              ? "999999" // จำกัดตัวเลขสูงสุด 6 หลัก
                              : pointsValue.toStringAsFixed(2); // ปัดเศษ 2 ตำแหน่ง

                      return Text(
                        displayPoints,
                        style: TextStyle(
                          fontSize: 24,
                          foreground: Paint()
                            ..shader = AppGradiant.gradientX_1.createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),

            // ใช้ Expanded + Align เพื่อให้ "ประวัติ" ชิดขวาเสมอ
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.to(() => const HistoryView()),
                  child: Container(
                    width: 120, // ป้องกัน Overflow
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 209, 234, 255),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.av_timer_rounded, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "ประวัติ",
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
