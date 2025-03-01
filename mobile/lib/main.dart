import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Correct import
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/services/api_urls.dart';
import './modules/controllers/middleware/auth_middleware.dart';

void main() {
  // เรียกใช้ initializeDateFormatting ก่อน
  initializeDateFormatting('th_TH', null).then((_) {
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
          title: 'Rimpa',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode, // ใช้ themeMode ที่อัพเดตด้วย Obx
          initialRoute: AppPages.initial,
          debugShowCheckedModeBanner: false,
          getPages: AppPages.routes,
        ));
  }
}
