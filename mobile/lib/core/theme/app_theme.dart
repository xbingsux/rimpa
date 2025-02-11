import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFFCFBFC), // พื้นหลังสี #FCFBFC
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFFFCFBFC), // BottomSheet สี #FCFBFC
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    cardColor: const Color(0xFFFCFBFC), // ปรับสีของ Card เป็น #FCFBFC

    fontFamily: 'fontappsetting',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      displayLarge: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black, // พื้นหลังดำสนิท
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor:
          Color.fromARGB(255, 26, 25, 25), // ปรับ BottomSheet เป็นเทาเข้ม
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    cardColor: const Color(0xFF2C2C2C), // ปรับสีของ Card ให้ไม่กลืนกับพื้นหลัง
    fontFamily: 'fontappsetting',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      displayLarge: TextStyle(color: Colors.white),
    ),
  );
}
