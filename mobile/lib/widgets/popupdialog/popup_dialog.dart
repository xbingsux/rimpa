import 'package:flutter/material.dart';

class PopupDialog {
  static Future<void> checkAndShowPopup(BuildContext context) async {
    // แสดง Popup ทันทีที่เรียกใช้ ไม่ต้องเช็คเวลา
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันกดข้างนอกเพื่อปิด
      builder: (context) => _buildPopup(context),
    );
  }

  static Widget _buildPopup(BuildContext context) {
    final theme = Theme.of(context); // ใช้ธีมที่กำหนดใน app

    return Stack(
      alignment: Alignment.bottomCenter, // ตำแหน่งของปุ่มจะอยู่ที่ขอบล่าง
      children: [
        // ป็อปอัพหลัก
        AlertDialog(
          backgroundColor: theme.cardColor, // ใช้สีจากธีม
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active,
                  size: 40, color: theme.primaryColor),
              SizedBox(height: 10),
              Text(
                "แจ้งเตือนใหม่!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color, // ใช้สีจากธีม
                ),
              ),
              SizedBox(height: 10),
              Text(
                "นี่คือการแจ้งเตือนพิเศษของคุณ\nคุณได้รับการแจ้งเตือนล่าสุด",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color), // ใช้สีจากธีม
              ),
            ],
          ),
        ),

        // ปุ่มกากบาทอยู่นอก popup ด้านล่าง
        Positioned(
          bottom: 210, // ขยับปุ่มให้ใกล้ขอบล่าง
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 25,
              child: Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}
