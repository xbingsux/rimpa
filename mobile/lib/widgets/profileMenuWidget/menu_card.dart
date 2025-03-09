import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/constant/app.constant.dart';
import 'package:get/get.dart';

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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTextColors.white, // ใช้สีเดียวกับ Card
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary, width: 1), // เพิ่มเส้นขอบสีดำขนาด 3
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16, left: 16, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// หัวข้อ Card
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: AppTextSize.sm, // กำหนดขนาดฟอนต์
                    fontWeight: FontWeight.w100,
                    color: AppTextColors.secondary, // เปลี่ยนสีข้อความตามธีม
                  ),
            ),
            Gap(10),

            /// รายการเมนู
            Column(
              children: widget.items.map((item) {
                // ตรวจสอบว่าเมนูนี้เป็น Toggle หรือไม่
                if (item.isToggle) {
                  // เมนูแบบ Toggle
                  return ListTile(
                    leading: Icon(item.icon, color: Colors.grey, size: 18), // สีเทา
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppTextSize.sm,
                            fontWeight: FontWeight.w700, // กำหนดขนาดฟอนต์
                            color: isDarkMode ? Colors.white : Colors.black, // เปลี่ยนสีข้อความตามธีม
                          ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8, // ลดขนาดของ Switch
                      child: Switch(
                        value: toggleState[item.title] ?? false, // ใช้สถานะจาก Map
                        onChanged: (value) {
                          setState(() {
                            toggleState[item.title] = value; // เปลี่ยนสถานะ Toggle
                          });
                        },
                        activeColor: Colors.blue, // สีฟ้าสำหรับสถานะเปิด
                        inactiveThumbColor: Colors.grey, // สีของปุ่มเมื่อตัวเลือกปิด
                      ),
                    ),
                    onTap: () {
                      // ใช้ Get.toNamed กับ item.route
                      Get.toNamed(item.route); // นำทางไปยังหน้าตาม route ที่กำหนดใน MenuItem
                    },
                  );
                } else {
                  // เมนูปกติที่มีปุ่มกด
                  return ListTile(
                    minTileHeight: 40,
                    leading: Icon(item.icon, color: Colors.grey), // สีเทา
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppTextSize.md,
                            fontWeight: FontWeight.w600, // กำหนดขนาดฟอนต์ // กำหนดขนาดฟอนต์
                            color: Colors.black, // เปลี่ยนสีข้อความตามธีม
                          ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTextColors.secondary,
                    ),
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
