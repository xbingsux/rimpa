import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/theme_controller.dart';

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
    return SizedBox(
      width: double.infinity, // ขนาดปุ่มเต็มจอ
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 18),
          backgroundColor: const Color(0xFF1E88E5), // สีน้ำเงิน
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          shadowColor: Colors.blue.withOpacity(0.4),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    return SizedBox(
      width: double.infinity, // ขนาดปุ่มเต็มจอ
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 18),
          backgroundColor: const Color(0xFFE0E0E0), // สีเทาอ่อน
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.3),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

// ช่องOTP
class OTPInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final int? maxLength;

  const OTPInputField({
    Key? key,
    this.controller,
    required this.labelText,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        textAlign: TextAlign.center, // ให้ข้อความอยู่ตรงกลาง
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// ช่องกรอกสร้างบัญชี
class CreatTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final Function(String) onChanged;

  // Constructor ที่รับค่าจากภายนอก
  const CreatTextField({
    Key? key,
    required this.labelText,
    required this.obscureText,
    this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText, // การตั้งค่าให้ซ่อนข้อความหากเป็นรหัสผ่าน
      onChanged: onChanged, // รับค่าเมื่อมีการเปลี่ยนแปลงข้อความ
      decoration: InputDecoration(
        labelText: labelText, // แสดง label สำหรับช่องกรอกข้อมูล
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
