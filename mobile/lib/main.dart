import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/date_symbol_data_local.dart'; // Correct import
import 'package:get/get.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/core/constant/shared_pref.dart';
import 'package:rimpa/widgets/loading/app_loading.dart';
import 'package:rimpa/modules/controllers/getusercontroller/auth_service.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:upgrader/upgrader.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/services/api_urls.dart';
import './modules/controllers/middleware/auth_middleware.dart';
// Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th_TH', null); // Correct call
  configLoading();
  Get.put(AuthService());
  Get.put(AuthMiddleware());
  Get.put(ApiUrls());
  Get.put(ThemeController());
  await SharedPrefService().init();
  _clearCache();
  await checkVersion();
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..backgroundColor = Colors.transparent
    ..boxShadow = []
    ..indicatorWidget = const AppLoading()
    ..maskType = EasyLoadingMaskType.black
    ..indicatorColor = const Color(0xFF8866F6)
    ..textColor = const Color(0xFF009ACD)
    ..userInteractions = false
    ..dismissOnTap = false;
}

void _clearCache() async {
    await DefaultCacheManager().emptyCache(); // ล้างแคชทั้งหมด
  }

Future<void> checkVersion() async{
  final upgrader = Upgrader.sharedInstance;
  await upgrader.initialize();

  if (upgrader.isUpdateAvailable()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showUpdateDialog();
    });
  }
}

void showUpdateDialog() {
  showDialog(
    context: Get.context!,
    barrierDismissible: false, // บังคับไม่ให้ปิด Dialog นอก
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm)
          ),
          contentPadding: const EdgeInsets.only(left: AppSpacing.lg, right: AppRadius.lg, bottom: AppSpacing.lg),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppImageComponent(imageType: AppImageType.assets, imageAddress: 'assets/images/update/update.png'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return AppGradiant.gradientY_1.createShader(bounds);
                    },
                    child: Text(
                      'อัปเดตใหม่',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTextColors.white
                        ),
                    ),
                  ),
                  Text(
                    '  🚀✨',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'เพื่อให้คุณได้รับประสบการณ์ที่ดีที่สุด',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: AppTextSize.md,
                      fontWeight: FontWeight.w400,
                      color: AppTextColors.secondary,
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      StoreRedirect.redirect(
                        androidAppId: "co.newdice.goconapp",
                        iOSAppId: "6482293361", // ID สำหรับเทสเท่านั้น
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppGradiant.gradientX_1,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: AppSpacing.xl),
                      child: Text(
                        'อัปเดตตอนนี้',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: AppTextSize.md,
                            fontWeight: FontWeight.w600,
                            color: AppTextColors.white,
                          ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() => GetMaterialApp(
          title: 'Go Con',
          builder: EasyLoading.init(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode, // ใช้ themeMode ที่อัพเดตด้วย Obx
          initialRoute: AppPages.initial,
          debugShowCheckedModeBanner: false,
          getPages: AppPages.routes,
        ));
  }
}
