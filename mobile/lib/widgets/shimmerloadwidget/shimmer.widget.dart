import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // เพิ่มการใช้งาน shimmer package

// ฟังก์ชันสำหรับแสดง Shimmer Effect
Widget shimmerLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: double.infinity,
      height: 48.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
