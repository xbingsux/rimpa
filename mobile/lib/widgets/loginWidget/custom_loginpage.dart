import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import '../../core/theme/theme_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E54FD), // สีแรก
              Color(0xFF0ACCF5), // สีที่สอง
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20), // ขอบมน
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // สีข้อความ
            padding: EdgeInsets.symmetric(vertical: 18),
            backgroundColor:
                Colors.transparent, // ทำให้ปุ่มโปร่งใสเพื่อให้เห็น Gradient
            shadowColor: Colors.blue.withOpacity(0.4),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                ), // ใช้ฟอนต์จาก Theme
          ),
        ),
      ),
    );
  }
}

// ปุ่มสร้างบัญชี
class CreateAccountButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateAccountButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: Colors.grey, // "ยังไม่มีบัญชี" สีเทาอ่อน
              ),
          children: [
            const TextSpan(text: 'ยังไม่มีบัญชี? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: onPressed,
                child: Text(
                  'สมัครสมาชิก',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue, // สีฟ้า
                    decoration: TextDecoration.underline, // ขีดเส้นใต้
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ปุ่มสร้างบัญชี
class backlogin extends StatelessWidget {
  final VoidCallback onPressed;

  const backlogin({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: Colors.grey, // "ยังไม่มีบัญชี" สีเทาอ่อน
              ),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: onPressed,
                child: Text(
                  'กลับไปหน้าล็อคอิน',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue, // สีฟ้า
                    decoration: TextDecoration.underline, // ขีดเส้นใต้
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// มีบัญซีอยู่แล้ว
class Haveaccountbutton extends StatelessWidget {
  final VoidCallback onPressed;

  const Haveaccountbutton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: Colors.grey, // "ยังไม่มีบัญชี" สีเทาอ่อน
              ),
          children: [
            const TextSpan(text: 'มีบัญซีอยู่แล้ว? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: onPressed,
                child: Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue, // สีฟ้า
                    decoration: TextDecoration.underline, // ขีดเส้นใต้
                  ),
                ),
              ),
            ),
          ],
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
      style: const TextStyle(
          fontSize: AppTextSize.sm,
          color: Color.fromARGB(255, 158, 158, 158)), // สีข้อความปกติ
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: AppTextSize.sm,
          color: Color.fromARGB(255, 95, 95, 95), // สีข้อความ label เทาอ่อน
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้ง
          borderSide: const BorderSide(
            color: Color.fromARGB(
                255, 163, 163, 163), // สีกรอบเทาอ่อนเมื่อไม่ได้โฟกัส
            width: 1, // ความหนาของเส้นปรับเป็น 1 เพื่อให้แสดงผลถูกต้อง
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้งเหมือนเดิม
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 37, 37, 37), // สีกรอบดำเข้มเมื่อโฟกัส
            width: 2, // ทำให้เส้นตอนโฟกัสดูเด่นขึ้น
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFDFDFD), // สีพื้นหลังขาวนวล
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 16), // ปรับช่องว่างในกรอบ
      ),
    );
  }
}

// ช่องกรอกข้อมูล
class Customtextprofile extends StatelessWidget {
  final String labelText;
  final bool obscureText;

  const Customtextprofile({
    Key? key,
    required this.labelText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(
          fontSize: AppTextSize.sm,
          color: Color.fromARGB(255, 158, 158, 158)), // สีข้อความปกติ
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: AppTextSize.sm,
          color: Color.fromARGB(255, 95, 95, 95), // สีข้อความ label เทาอ่อน
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้ง
          borderSide: const BorderSide(
            color: Color.fromARGB(
                255, 163, 163, 163), // สีกรอบเทาอ่อนเมื่อไม่ได้โฟกัส
            width: 1, // ความหนาของเส้นปรับเป็น 1 เพื่อให้แสดงผลถูกต้อง
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้งเหมือนเดิม
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 37, 37, 37), // สีกรอบดำเข้มเมื่อโฟกัส
            width: 2, // ทำให้เส้นตอนโฟกัสดูเด่นขึ้น
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFDFDFD), // สีพื้นหลังขาวนวล
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 16), // ปรับช่องว่างในกรอบ
      ),
    );
  }
}

// ช่องกรอกสำหรับเบอร์โทร
class CustomPhoneTextField extends StatelessWidget {
  const CustomPhoneTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'เบอร์โทรศัพท์มือถือ',
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 50, 50, 50), // สีดำอ่อนๆ
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 180, 180, 180), // กรอบเทาอ่อน
            width: 1,
          ),
        ),
        filled: true,
        fillColor: Colors.white, // พื้นหลังขาว
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      initialCountryCode: 'TH', // ให้ค่าเริ่มต้นเป็นประเทศไทย 🇹🇭
      showCountryFlag: true, // แสดงธงชาติ
      dropdownTextStyle: const TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 50, 50, 50), // สีดำอ่อนๆ
      ),
      dropdownIcon: const Icon(
        Icons.arrow_drop_down,
        color: Color.fromARGB(255, 50, 50, 50), // สีดำอ่อน
        size: 24,
      ), // ไอคอนลูกศรเลือกประเทศ
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25), // โค้งมน
      ),
      disableLengthCheck: true, // ปิดการตรวจสอบความยาวหมายเลข
    );
  }
}

// ช่องกรอกสร้างบัญชี
class CreatTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final Function(String) onChanged;

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
      obscureText: obscureText,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge, // ใช้ฟอนต์จาก Theme
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: AppTextSize.sm,
              color: const Color(0xFF616161), // สีข้อความ label อ่อนลง
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // มุมกรอบโค้ง
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color(0xFF1E88E5), width: 2), // สีน้ำเงินเมื่อเลือก
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 253, 253, 253), // สีพื้นหลังอ่อน
        contentPadding: const EdgeInsets.symmetric(
            vertical: 18, horizontal: 16), // ปรับช่องว่างในกรอบ
      ),
    );
  }
}

// ลืมรหัสผ่านและจำรหัผ่าน
class RememberPasswordWidget extends StatelessWidget {
  final bool rememberPassword;
  final Function(bool) onRememberChanged;
  final Function() onForgotPassword;

  RememberPasswordWidget({
    required this.rememberPassword,
    required this.onRememberChanged,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: rememberPassword,
                onChanged: (value) => onRememberChanged(value!),
                activeColor: Colors.blue,
                checkColor: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                "จำฉันไว้ไหม",
                style: TextStyle(
                  color: rememberPassword
                      ? (isDarkMode ? Colors.white : Colors.black)
                      : (isDarkMode ? Colors.white54 : Colors.grey),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onForgotPassword,
            child: Text(
              "ลืมรหัสผ่าน?",
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// หรือ///
class Ordesign extends StatelessWidget {
  final String text;

  const Ordesign({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[400], // สีของเส้นขีด
            thickness: 1, // ความหนาของเส้น
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppTextSize.xs,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // สีข้อความ
              ),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

// ล็อคอินโซเซียล
class SocialLoginButtons extends StatelessWidget {
  final Function()? onGooglePressed;
  final Function()? onApplePressed;
  final Function()? onFacebookPressed;

  const SocialLoginButtons({
    Key? key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSocialButton(
          icon: Icons.g_translate, // ไอคอน Google
          color: const Color.fromARGB(255, 218, 218, 218),
          onTap: onGooglePressed,
          text: 'ล็อกอินด้วย Google',
        )
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required Function()? onTap,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // ให้ปุ่มเต็มความกว้าง
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
