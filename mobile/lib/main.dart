import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/services/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './modules/controllers/middleware/auth_middleware.dart';
import 'package:intl/intl.dart';  // เพิ่มการ import intl
import 'package:intl/date_symbol_data_local.dart'; // เพิ่มการ import สำหรับการจัดการวันที่

void main() {
  // เรียกใช้ initializeDateFormatting ก่อน
  initializeDateFormatting('th_TH', null).then((_) {
    // เรียกใช้ middleware และ service ต่างๆ
    Get.put(AuthMiddleware());
    Get.put(ApiUrls());
    Get.put(ThemeController());
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() => GetMaterialApp(
          title: 'Login rimpa 66',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeController.themeMode, // ใช้ themeMode ที่อัพเดตด้วย Obx
          initialRoute: AppPages.initial,
          debugShowCheckedModeBanner: false,
          getPages: AppPages.routes,
        ));
  }
}
