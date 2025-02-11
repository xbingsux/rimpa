import 'package:flutter/material.dart';
import '../../core/constant/app.constant.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final bool isToggle; // เพิ่มตัวแปรเช็คว่าเป็นเมนูแบบ Toggle หรือไม่

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.isToggle = false, // ค่าเริ่มต้นเป็น false หากไม่ใช่ Toggle
  });
}

class MenuCard extends StatefulWidget {
  final String title;
  final List<MenuItem> items;

  const MenuCard({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  // สร้าง Map เพื่อเก็บสถานะ Toggle ของแต่ละเมนู
  Map<String, bool> toggleState = {};

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบธีมที่ใช้งาน
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor, // ใช้สีการ์ดจากธีม
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// หัวข้อ Card
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: AppTextSize.sm, // กำหนดขนาดฟอนต์
                    fontWeight: FontWeight.w100,
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black, // เปลี่ยนสีข้อความตามธีม
                  ),
            ),

            /// รายการเมนู
            Column(
              children: widget.items.map((item) {
                // ตรวจสอบว่าเมนูนี้เป็น Toggle หรือไม่
                if (item.isToggle) {
                  // เมนูแบบ Toggle
                  return ListTile(
                    leading: Icon(item.icon, color: Colors.grey), // สีเทา
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppTextSize.sm,
                            fontWeight: FontWeight.w700, // กำหนดขนาดฟอนต์
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black, // เปลี่ยนสีข้อความตามธีม
                          ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8, // ลดขนาดของ Switch
                      child: Switch(
                        value:
                            toggleState[item.title] ?? false, // ใช้สถานะจาก Map
                        onChanged: (value) {
                          setState(() {
                            toggleState[item.title] =
                                value; // เปลี่ยนสถานะ Toggle
                          });
                        },
                        activeColor: Colors.blue, // สีฟ้าสำหรับสถานะเปิด
                        inactiveThumbColor:
                            Colors.grey, // สีของปุ่มเมื่อตัวเลือกปิด
                      ),
                    ),
                    onTap: () {
                      // สามารถทำงานอื่นๆ ได้ที่นี่
                    },
                  );
                } else {
                  // เมนูปกติที่มีปุ่มกด
                  return ListTile(
                    leading: Icon(item.icon, color: Colors.grey), // สีเทา
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppTextSize.sm,
                            fontWeight: FontWeight
                                .w700, // กำหนดขนาดฟอนต์ // กำหนดขนาดฟอนต์
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black, // เปลี่ยนสีข้อความตามธีม
                          ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 12),
                    onTap: () {
                      Navigator.pushNamed(context, item.route);
                    },
                  );
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
