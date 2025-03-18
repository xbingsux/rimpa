import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import '../../../widgets/loginWidget/custom_loginpage.dart';

class PhoneLoginForm extends StatelessWidget {
  final String phoneNumber;

  PhoneLoginForm({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.5, //  ตั้งให้สูง 50% ของจอ
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        children: [
          // 🔹 แถวบน: ปุ่มย้อนกลับ + หัวข้อ
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(), // ปิด Bottom Sheet
              ),
              const SizedBox(width: 8),
              const Text(
                'สมัครสมาชิก',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ใส่เบอร์โทรศัพท์',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
           const SizedBox(height: AppSpacing.md),
          //  ฟิลด์ป้อนเบอร์โทร
          const CustomPhoneTextField(
            
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
            '*ระบบจะส่ง OTP ไปยังโทรศัพท์ของคุณ',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),

          const Spacer(), //  ดันปุ่มไปอยู่ล่างสุด
          // 🔹 ปุ่มยืนยัน (อยู่ล่างเสมอ)
          Padding(
            padding:
                const EdgeInsets.only(bottom: 16.0), //  ป้องกันปุ่มติดขอบล่าง
            child: SizedBox(
              width: double.infinity, //  ปุ่มเต็มจอ
              child: CustomButton(
                text: 'ยืนยัน',
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
