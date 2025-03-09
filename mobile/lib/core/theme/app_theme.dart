import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColors.whisperGray,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.whisperGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    cardColor: AppColors.whisperGray,
    fontFamily: 'fontappsetting',
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.ibmPlexSansThai(
        textStyle: TextStyle(
          color: Color.fromARGB(255, 238, 238, 238),
        ),
      ),
      bodyMedium: GoogleFonts.ibmPlexSansThai(
        textStyle: TextStyle(
          color: Color.fromARGB(255, 36, 36, 36),
        ),
      ),
      displayLarge: GoogleFonts.ibmPlexSansThai(
        textStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black, // พื้นหลังดำสนิท
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 26, 25, 25), // ปรับ BottomSheet เป็นเทาเข้ม
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    cardColor: const Color(0xFF2C2C2C), // ปรับสีของ Card ให้ไม่กลืนกับพื้นหลัง
    fontFamily: 'fontappsetting',
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.ibmPlexSansThai(
        textStyle: TextStyle(color: Colors.white),
      ),
      bodyMedium: GoogleFonts.ibmPlexSansThai(
        textStyle: TextStyle(color: Colors.white),
      ),
      displayLarge: GoogleFonts.ibmPlexSansThai(
        textStyle: TextStyle(color: Colors.white),
      ),
    ),
  );
}
