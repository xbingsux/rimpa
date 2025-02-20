import 'package:flutter/material.dart';

class AppColors {
  /// สีหลัก Dodger Blue
  static const Color primary = Color(0xFF1093ED);

  /// สีเทารอง ตัดกับสีหลัก
  static const Color secondary = Color(0xFFD9D9D9);

  /// สีเน้นส่วนสำคัญ Bright Blue
  static const Color accent = Color(0xFF1E54FD);
  static const Color accent1 = Color(0xFFEBF5FD);
  /// สีเน้นส่วนสำคัญ Sky Blue
  static const Color accent2 = Color(0xFF0ACCF5);

  /// สีพื้นหลังหลัก
  static const Color background_main = Color(0xFFF2F2F4);

  /// สีขาวสุด #FFFFFF
  static const Color white = Color(0xFFFFFFFF);

  /// สีขาวนวล #F8F9FA
  static const Color light = Color(0xFFF8F9FA);

  /// สีดำสุด #000000
  static const Color black = Color(0xFF000000);

  /// สีดำมืด #212529
  static const Color dark = Color(0xFF212529);

  /// สีฟ้าอ่อน info #0DCAF0
  static const Color info = Color(0xFF0DCAF0);

  /// สีเขียว success #198754
  static const Color success = Color(0xFF198754);

  /// สีเหลือง warning info #FFC107
  static const Color warning = Color(0xFFFFC107);

  /// สีแดง danger #DC3545
  static const Color danger = Color(0xFFDC3545);
}

class AppTextColors {
  /// สีฟ้อนท์หลัก
  static const Color primary = Color(0xFF000000);

  /// สีฟ้อนรอง
  static const Color secondary = Color(0xFF999999);

  /// สีเน้นหัวข้อ
  static const Color accent = Color(0xFF1E54FD);

  /// สีเน้นข้อความ
  static const Color accent2 = Color(0xFF1093ED);

  /// สีขาวสุด #FFFFFF
  static const Color white = Color(0xFFFFFFFF);

  /// สีขาวนวล #F8F9FA
  static const Color light = Color(0xFFF8F9FA);

  /// สีดำสุด #000000
  static const Color black = Color(0xFF000000);

  /// สีดำมืด #212529
  static const Color dark = Color(0xFF212529);

  /// สีฟ้าอ่อน info #0DCAF0
  static const Color info = Color(0xFF0DCAF0);

  /// สีเขียว success #198754
  static const Color success = Color(0xFF198754);

  /// สีเหลือง warning info #FFC107
  static const Color warning = Color(0xFFFFC107);

  /// สีแดง danger #DC3545
  static const Color danger = Color(0xFFDC3545);
}

class AppTextSize {
  /// 8.0 - Extra Extra Small
  static const double xxs = 8.0;

  /// 12.0 - Extra Small
  static const double xs = 12.0;

  /// 14.0 - Small
  static const double sm = 14.0;

  /// 16.0 - Medium
  static const double md = 16.0;

  /// 18.0 - Large
  static const double lg = 18.0;

  /// 20.0 - Extra Large
  static const double xl = 20.0;

  /// 24.0 - Extra Extra Large
  static const double xxl = 24.0;
}

class AppSpacing {
  /// 2.0 - Extra Extra Small
  static const double xxs = 2.0;

  /// 4.0 - Extra Small
  static const double xs = 4.0;

  /// 8.0 - Small
  static const double sm = 8.0;

  /// 16.0 - Medium
  static const double md = 16.0;

  /// 24.0 - Large
  static const double lg = 24.0;

  /// 32.0 - Extra Large
  static const double xl = 32.0;

  /// 40.0 - Extra Extra Large
  static const double xxl = 40.0;
}

class AppRadius {
  /// 4.0 - Extra Extra Small
  static const double xxs = 4.0;

  /// 8.0 - Extra Small
  static const double xs = 8.0;

  /// 16.0 - Small
  static const double sm = 16.0;

  /// 24.0 - Medium
  static const double md = 24.0;

  /// 28.0 - Large (แก้ให้ต่างจาก md)
  static const double lg = 28.0;

  /// 32.0 - Extra Large
  static const double xl = 32.0;

  /// 40.0 - Extra Extra Large
  static const double xxl = 40.0;

  /// 1000.0 - Fully Rounded (ใช้สำหรับทำมุมโค้งสุดๆ)
  static const double rounded = 1000.0;
}

class AppShadow {
  /// Light shadow effect - เงาที่สว่าง
  static const BoxShadow lightShadow = BoxShadow(
    blurRadius: 2.0, // ค่ารัศมีเบลอ
    color: AppColors.light, // ใช้สีจาก AppColors.light
  );

  /// Dark shadow effect - เงาที่ดำ
  static const BoxShadow darkShadow = BoxShadow(
    blurRadius: 2.0, // ค่ารัศมีเบลอ
    color: AppColors.dark, // ใช้สีจาก AppColors.dark
  );

  /// Custom shadow effect - เงาที่สามารถปรับแต่งเองได้
  /// [color] - สีของเงา
  /// [blurRadius] - ค่ารัศมีเบลอของเงา (default = 2.0)
  /// [offset] - ระยะห่างของเงา (default = (0, 0))
  /// [spreadRadius] - การขยายขนาดของเงา (default = 0.0)
  static BoxShadow custom({
    required Color color, // สีของเงา
    double blurRadius = 2.0, // ค่ารัศมีเบลอ
    Offset offset = const Offset(0, 0), // ระยะห่างของเงา
    double spreadRadius = 0.0, // การขยายของเงา
  }) {
    return BoxShadow(
      color: color, // กำหนดสี
      blurRadius: blurRadius, // กำหนดรัศมีเบลอ
      offset: offset, // กำหนดระยะห่าง
      spreadRadius: spreadRadius, // กำหนดการขยาย
    );
  }
}

class AppGradiant {
  static const LinearGradient gradientY_1 = LinearGradient(
      colors: [AppColors.accent, AppColors.accent2],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  static const LinearGradient gradientX_1 = LinearGradient(
      colors: [AppColors.accent, AppColors.accent2],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);
}
