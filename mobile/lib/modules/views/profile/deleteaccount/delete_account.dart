import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth.controller.dart';
import '../../../../core/constant/app.constant.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบโหมดธีมที่ใช้งาน
    final authController = Get.put(LoginController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.black.withOpacity(0.8) // สีดำอ่อนๆ เมื่อโหมดมืด
            : Theme.of(context)
                .scaffoldBackgroundColor, // ใช้สีพื้นฐานในโหมดปกติ
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.blue), // ปุ่มย้อนกลับ
          onPressed: () => Get.back(), // ใช้ GetX สำหรับย้อนกลับ
        ),
        title: const Text(
          "ลบบัญชี",
          style: TextStyle(color: Colors.black), // ปรับสีตามธีมที่ใช้งาน
        ),
        centerTitle: false, // ย้าย title ไปทางซ้าย
      ),
      body: Container(
        color: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor // ใช้สีพื้นหลังตามธีม
            : Colors.white, // กำหนดสีพื้นหลังเมื่อไม่ใช่โหมดมืด
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // หัวข้อ "โปรดทราบ!" ให้เป็นสีฟ้า
              const Text(
                "โปรดทราบ!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // สีฟ้า
                ),
              ),
              const SizedBox(height: 8),

              // เนื้อหาหลักที่มีดอทนำหน้า
              const Text(
                "• เมื่อคุณลบบัญชี\n"
                "• ข้อมูลทั้งหมดของคุณจะถูกลบถาวร\n"
                "• ข้อมูลส่วนตัว เช่น ชื่อผู้ใช้ อีเมล เบอร์โทรศัพท์ รวมถึงประวัติการใช้งานจะถูกลบออกจากระบบโดยไม่สามารถกู้คืนได้\n"
                "• คุณจะไม่สามารถกู้คืนบัญชีนี้ได้\n"
                "• เมื่อลบบัญชีแล้ว คุณจะไม่สามารถลงชื่อเข้าใช้บัญชีเดิมได้อีก หากต้องการใช้บริการใหม่ จะต้องสมัครบัญชีใหม่เท่านั้น\n"
                "• การเข้าถึงบริการต่าง ๆ จะถูกยกเลิก\n"
                "• คุณจะไม่สามารถใช้ฟีเจอร์ที่ต้องใช้บัญชีของคุณ เช่น การบันทึกข้อมูล การซิงค์ข้อมูลระหว่างอุปกรณ์ หรือสิทธิ์การเข้าถึงเนื้อหาพิเศษได้อีกต่อไป",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 30),

              // Spacer ที่จะผลักดันปุ่มไปอยู่ที่ด้านล่าง
              const Spacer(),

              // ปุ่มยืนยันลบและยกเลิก
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ปุ่มยกเลิก
                  Expanded(
                    child: Custombottomaccep(
                      text: 'ยกเลิก',
                      onPressed: () => Get.back(),
                      buttonColor: const Color.fromARGB(
                          255, 219, 218, 218), // สีเทาสำหรับปุ่มยกเลิก
                      gradient: AppGradiant.gradientX_1, // ใช้ gradient
                      borderRadius:
                          BorderRadius.circular(20), // border radius 20
                    ),
                  ),
                  const SizedBox(width: 10), // เว้นระยะห่างระหว่างปุ่ม
                  // ปุ่มยืนยันลบ
                  Expanded(
                    child: Custombottomaccep(
                      text: 'ยืนยันลบ',
                      onPressed: () => authController.deleteAccount(),
                      buttonColor: Colors.transparent, // ไม่มีสีพื้นหลัง
                      gradient: AppGradiant.gradientX_1, // ใช้ gradient
                      borderRadius:
                          BorderRadius.circular(20), // border radius 20
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Custombottomaccep extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final LinearGradient gradient;
  final BorderRadius borderRadius;

  const Custombottomaccep({
    required this.text,
    required this.onPressed,
    this.buttonColor = Colors.blue,
    required this.gradient,
    required this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: buttonColor, // สีตัวอักษร
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius, // กำหนด border radius
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius, // กำหนด border radius
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
