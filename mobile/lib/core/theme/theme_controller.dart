import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var _themeMode = ThemeMode.light.obs; // ใช้ Rx เพื่ออัพเดตทันที
 
  ThemeMode get themeMode => _themeMode.value;
 
  void toggleTheme() {
    _themeMode.value =
        _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
