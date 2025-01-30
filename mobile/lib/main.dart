import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'modules/services/api_urls.dart';

void main() {
  Get.put(ApiUrls());
  Get.put(ThemeController());
  runApp(MyApp());
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
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
        ));
  }
}
