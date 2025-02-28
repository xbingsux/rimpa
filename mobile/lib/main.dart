import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Correct import
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/services/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './modules/controllers/middleware/auth_middleware.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th_TH', null); // Correct call
  Get.put(AuthMiddleware());
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
          debugShowCheckedModeBanner: false,
          getPages: AppPages.routes,
        ));
  }
}
