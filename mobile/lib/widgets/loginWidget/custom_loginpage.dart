import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import '../../core/theme/theme_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';

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

class CustomButtonResetpassword extends StatelessWidget {
  final String text;
  final VoidCallback?
      onPressed; // เปลี่ยนเป็น VoidCallback? เพื่อรองรับค่า null

  const CustomButtonResetpassword({
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

class CustomDatePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime) onChanged;

  const CustomDatePicker({
    Key? key,
    required this.labelText,
    required this.selectedDate,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.blue, // ปรับสีปุ่มและพื้นหลัง
                dialogBackgroundColor: Colors.white, // สีพื้นหลังของ dialog
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
                colorScheme: ColorScheme.light(primary: Colors.blue)
                    .copyWith(background: Colors.white),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          onChanged(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText, // ใช้ label ที่เป็นภาษาไทย
          labelStyle: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500, // เพิ่มความหนาให้ตัวอักษร
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white, // สีพื้นหลังเป็นสีขาว
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedDate == null
                  ? 'กรุณาเลือกวันที่เกิด'
                  : '${DateFormat('d MMMM yyyy').format(selectedDate!)}', // แสดงวันที่พร้อมเดือนไทย
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 158, 158, 158),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String? selectedValue;
  final Function(String?) onChanged;
  final List<String> items;

  const CustomDropdown({
    Key? key,
    required this.labelText,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Colors.grey, // สีข้อความ label
          fontWeight: FontWeight.w500, // เพิ่มความหนาให้ตัวอักษร
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้ง
          borderSide: const BorderSide(
            color: Color.fromARGB(
                255, 163, 163, 163), // สีกรอบเทาอ่อนเมื่อไม่ได้โฟกัส
            width: 1, // ความหนาของเส้น
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้งเหมือนเดิม
          borderSide: const BorderSide(
            color: Colors.blueAccent, // สีกรอบตอนโฟกัส
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFDFDFD), // สีพื้นหลังขาวนวล
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 16), // ปรับช่องว่างในกรอบ
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: const Text('กรุณาเลือก'),
        isExpanded: true,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black, // สีตัวหนังสือใน dropdown
        ),
        dropdownColor: const Color(0xFFFDFDFD), // สีพื้นหลังของ dropdown
        items: items.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final Function(String) onChanged;
  final bool isDateField;
  final bool isEmailField;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.obscureText,
    required this.onChanged,
    this.isDateField = false,
    this.isEmailField = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  String? _emailError;
  String? _passwordGuide;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _validateEmail(String value) {
    if (widget.isEmailField) {
      final emailRegExp =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegExp.hasMatch(value)) {
        setState(() {
          _emailError = 'กรุณากรอกอีเมลที่ถูกต้อง';
        });
      } else {
        setState(() {
          _emailError = null;
        });
      }
    }
  }

  void _validatePassword(String value) {
    if (widget.labelText == 'รหัสผ่าน') {
      setState(() {
        _passwordGuide =
            value.length < 6 ? 'รหัสผ่านควรมีอย่างน้อย 6 ตัวอักษร' : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          obscureText: _obscureText,
          onChanged: (value) {
            widget.onChanged(value);
            if (widget.isEmailField) _validateEmail(value);
            if (widget.labelText == 'รหัสผ่าน') _validatePassword(value);
          },
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 158, 158, 158),
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 95, 95, 95),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 163, 163, 163),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 37, 37, 37),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFFDFDFD),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            suffixIcon: (widget.labelText == 'รหัสผ่าน' ||
                    widget.labelText == 'ยืนยันรหัสผ่าน')
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                : null,
          ),
        ),
        if (_emailError != null) ...[
          SizedBox(height: 8),
          Text(
            _emailError!,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
        if (_passwordGuide != null) ...[
          SizedBox(height: 8),
          Text(
            _passwordGuide!,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

// ช่องกรอกข้อมูลรหัสผ่าน
// ช่องกรอกข้อมูลรหัสผ่านที่มีไอคอนเปิดตาปิดตา
class CustomTextFieldpassword extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final Function(String) onChanged;
  final Widget? suffixIcon; // เพิ่มตัวแปรสำหรับไอคอนที่ใช้ในการเปิดตาปิดตา

  const CustomTextFieldpassword({
    Key? key,
    required this.labelText,
    required this.obscureText,
    required this.onChanged,
    this.suffixIcon, // รับไอคอนที่เพิ่มเข้ามา
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 158, 158, 158),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 95, 95, 95),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 163, 163, 163),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 37, 37, 37),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFDFDFD),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        suffixIcon: suffixIcon, // แสดงไอคอนที่เพิ่มเข้ามา
      ),
    );
  }
}

// ช่องกรอกข้อมูล
class Customtextprofile extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;

  const Customtextprofile({
    Key? key,
    required this.labelText,
    required this.obscureText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // ใช้ controller สำหรับค่าที่กรอก
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 16, color: Color(0xFF5F5F5F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFFA3A3A3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF252525), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFFDFDFD),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}

class CustomResetpasswordfiule extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final ValueChanged<String> onChanged;

  const CustomResetpasswordfiule({
    Key? key,
    required this.labelText,
    required this.obscureText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText, // ใช้สำหรับซ่อนข้อความในฟิลด์กรอกข้อมูล
      onChanged: onChanged, // เรียกใช้ฟังก์ชันเมื่อมีการกรอกข้อมูล
      style: const TextStyle(
        fontSize: 16, // ปรับขนาดข้อความ
        color: Color.fromARGB(255, 158, 158, 158), // สีข้อความเมื่อไม่ได้โฟกัส
      ),
      decoration: InputDecoration(
        labelText: labelText, // ข้อความใน label
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 95, 95, 95), // สีข้อความ label เทาอ่อน
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้งมน
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 163, 163, 163), // สีกรอบปกติ
            width: 1, // ความหนาของเส้นกรอบ
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 37, 37, 37), // สีกรอบเข้มเมื่อโฟกัส
            width: 2, // ความหนาของกรอบเมื่อโฟกัส
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFFDFDFD), // สีพื้นหลังฟิลด์กรอกข้อมูล
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 16), // ช่องว่างภายในฟิลด์
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

class CustomPhoneTextFieldProfile extends StatelessWidget {
  final String phoneNumber;
  final TextEditingController controller;

  const CustomPhoneTextFieldProfile({
    Key? key,
    required this.phoneNumber,
    required this.controller, // ใช้ controller สำหรับกรอก
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        labelStyle: const TextStyle(fontSize: 16, color: Color(0xFF323232)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF000000), width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      initialCountryCode: 'TH',
      showCountryFlag: true,
      dropdownTextStyle:
          const TextStyle(fontSize: 16, color: Color(0xFF323232)),
      dropdownIcon:
          const Icon(Icons.arrow_drop_down, color: Color(0xFF323232), size: 24),
      dropdownDecoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25)),
      disableLengthCheck: true,
    );
  }
}

class CustomPhoneRegisTextField extends StatelessWidget {
  final Function(String) onChanged;

  const CustomPhoneRegisTextField({
    Key? key,
    required this.onChanged, // รับค่าจากภายนอกเมื่อมีการเปลี่ยนแปลง
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
      initialCountryCode: 'TH', // กำหนดประเทศเริ่มต้นเป็นประเทศไทย 🇹🇭
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
      onChanged: (phone) {
        // เมื่อมีการเปลี่ยนแปลงข้อมูล
        onChanged(
            phone.completeNumber); // ส่งค่าเบอร์โทรศัพท์ที่กรอกไปยังฟังก์ชัน
      },
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   icon,
            //   color: Colors.white,
            //   size: 28,
            // ),
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
