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
  final VoidCallback? onPressed; // เปลี่ยนเป็น VoidCallback? เพื่อรองรับค่า null

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
        );
        if (pickedDate != null) {
          onChanged(pickedDate); // ส่งค่าที่เลือกไปยัง controller
        }
      },
      child: InputDecorator(
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
          filled: true,
          fillColor: const Color(0xFFFDFDFD),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        child: Text(
          selectedDate == null
              ? 'กรุณาเลือกวันที่'
              : DateFormat('yyyy-MM-dd').format(selectedDate!), // รูปแบบการแสดงผล
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 158, 158, 158),
          ),
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
          fontSize: 14,
          color: Color.fromARGB(255, 95, 95, 95), // สีข้อความ label เทาอ่อน
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้ง
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 163, 163, 163), // สีกรอบเทาอ่อนเมื่อไม่ได้โฟกัส
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
      child: DropdownButton<String>(
        value: selectedValue,
        hint: const Text('เลือกเพศ'),
        isExpanded: true,
        onChanged: onChanged,
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


// ช่องกรอกข้อมูล
class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final Function(String) onChanged;
  final bool isDateField; // เพิ่มตัวแปรสำหรับเช็คว่าเป็นช่องวันที่

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.obscureText,
    required this.onChanged,
    this.isDateField = false, // กำหนดค่าเริ่มต้นเป็น false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: (value) {
        if (isDateField) {
          // ถ้าเป็นช่องวันที่ แปลงค่าจาก String เป็น DateTime
          try {
            // ใช้ DateFormat เพื่อแปลงวันที่จาก String ไปเป็น DateTime
            DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(value);
            // ส่งค่าผ่าน onChanged
            onChanged(parsedDate.toString());
          } catch (e) {
            print('Invalid date format');
            onChanged(value); // ถ้าผิดพลาด ก็ส่งค่าตามเดิม
          }
        } else {
          // ถ้าไม่ใช่ช่องวันที่ ก็ส่งค่าปกติ
          onChanged(value);
        }
      },
      style: const TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 158, 158, 158), // สีข้อความปกติ
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 95, 95, 95), // สีข้อความ label เทาอ่อน
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), // กรอบโค้ง
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 163, 163, 163), // สีกรอบเทาอ่อนเมื่อไม่ได้โฟกัส
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 16),
        suffixIcon: suffixIcon, // แสดงไอคอนที่เพิ่มเข้ามา
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
  final String phoneNumber;  // เพิ่มพารามิเตอร์นี้

  const CustomPhoneTextFieldProfile({
    Key? key,
    required this.phoneNumber,  // ใช้ required เพื่อให้ต้องรับค่า
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: phoneNumber);

    return IntlPhoneField(
      controller: controller,  // ใช้ controller สำหรับการจัดการค่าภายในฟิลด์
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
        onChanged(phone.completeNumber); // ส่งค่าเบอร์โทรศัพท์ที่กรอกไปยังฟังก์ชัน
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
