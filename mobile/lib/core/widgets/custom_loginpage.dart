import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_controller.dart';

// ปุ่มกดเข้าระบบ
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350, // ขนาดปุ่ม
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 18),
            backgroundColor:
                const Color(0xFF1E88E5), // สีน้ำเงินสำหรับปุ่ม login
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // ปรับมุมให้โค้งมากขึ้น
            ),
            elevation: 10, // ความลึกของปุ่ม
            shadowColor: Colors.blue.withOpacity(0.4), // เพิ่มเงาของปุ่ม
            minimumSize: Size(double.infinity, 50), // ขนาดปุ่มที่เหมาะสม
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold, // เพิ่มความเด่นให้ข้อความ
            ),
          ),
        ),
      ),
    );
  }
}

// ปุ่มสร้างบัญชี
class CreateAccountButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CreateAccountButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350, // ขนาดปุ่ม
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, // เปลี่ยนสีข้อความเป็นสีดำ
            padding: EdgeInsets.symmetric(vertical: 18),
            backgroundColor:
                const Color(0xFFE0E0E0), // สีเทาอ่อนสำหรับปุ่ม Create Account
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // ปรับมุมโค้ง
            ),
            elevation: 5, // ความลึกของปุ่ม
            shadowColor: Colors.grey.withOpacity(0.3), // สีเงาของปุ่ม
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold, // เพิ่มความเด่นให้ข้อความ
            ),
          ),
        ),
      ),
    );
  }
}

// ช่องกรอกข้อมูล
class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final Function(String) onChanged;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.obscureText,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16,
          color: const Color(0xFF616161), // สีข้อความ label อ่อนลง
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // มุมกรอบโค้ง
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: const Color(0xFF1E88E5), width: 2), // สีน้ำเงินเมื่อเลือก
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 253, 253, 253), // สีพื้นหลังอ่อน
        contentPadding: EdgeInsets.symmetric(
            vertical: 18, horizontal: 16), // ปรับช่องว่างในกรอบ
      ),
    );
  }
}
