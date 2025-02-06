import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // ตัวอักษรสีดำในธีม Light
      bodyMedium: TextStyle(color: Colors.black), // ตัวอักษรสีดำในธีม Light
      displayLarge: TextStyle(color: Colors.black), // หัวข้อสีดำในธีม Light
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0)), // ตัวอักษรสีขาวในธีม Dark
      bodyMedium: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0)), // ตัวอักษรสีขาวในธีม Dark
      displayLarge: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0)), // หัวข้อสีขาวในธีม Dark
    ),
  );
}
