import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Correct import
import 'package:get/get.dart';
import 'package:rimpa/core/constant/shared_pref.dart';
import 'package:rimpa/modules/controllers/getusercontroller/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/services/api_urls.dart';
import './modules/controllers/middleware/auth_middleware.dart';
// Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th_TH', null); // Correct call
  Get.put(AuthService());
  Get.put(AuthMiddleware());
  Get.put(ApiUrls());
  Get.put(ThemeController());
  await SharedPrefService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
