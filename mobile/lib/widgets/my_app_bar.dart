import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/controllers/profile/profile_controller.dart';
import 'package:rimpa/widgets/button/notifiction_button.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final bool darkMode;
  MyAppBar(
      {super.key, this.backgroundColor = Colors.white, this.darkMode = false});
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final ApiUrls apiUrls = Get.find();
  final profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor, // รองรับ Light/Dark Mode
      elevation: 0, forceMaterialTransparency: true,
      shadowColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // รูปโปรไฟล์แทนไอคอน
              Obx(() {
                // ดึงข้อมูล URL ของรูปโปรไฟล์จาก Controller
                String profileImage =
                    profileController.profileData["profile_img"] ?? '';

                // สร้าง URL ของภาพจาก path ที่ต้องการ
                String imageUrl = profileImage.isEmpty
                    ? 'assets/images/default_profile.jpg'
                    : '${apiUrls.imgUrl.value}$profileImage'; // กำหนด URL รูปโปรไฟล์

                return Container(
                  width: 40, // ขนาดเดิม
                  height: 40, // ขนาดเดิม
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300], // พื้นหลังเทาเหมือนเดิม
                  ),
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: 40, // ให้รูปอยู่ในขนาด 40x40 px
                      height: 40,
                      fit: BoxFit.cover, // ปรับให้เต็มวงกลม
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Iconsax.user,
                            color: Colors.grey, size: 24);
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(width: 8),
              Obx(() {
                var profileName =
                    profileController.profileData["profile_name"] ??
                        "ยังไม่มีข้อมูล";

                return Text(
                  profileName,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: darkMode
                            ? Colors.white
                            : Colors.black, // สีตัวอักษรดำหรือขาวตาม Dark Mode
                        fontSize: 16, // ปรับขนาดฟอนต์เป็น 16
                      ),
                );
              }),
            ],
          ),

          // ไอคอนแจ้งเตือน

          NotificationButton(
            isDark: darkMode,
          ),
        ],
      ),
    );
  }
}
