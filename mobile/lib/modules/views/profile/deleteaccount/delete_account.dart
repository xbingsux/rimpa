import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rimpa/modules/controllers/profile/profile_controller.dart';
import 'package:rimpa/modules/views/profile/deleteaccount/delete_confirm_account.dart';
import 'package:rimpa/widgets/button/botton.dart';
import '../../../controllers/auth.controller.dart';
import '../../../../core/constant/app.constant.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool checkbox1 = false;
  bool checkbox2 = false;
  @override
  Widget build(BuildContext context) {
    // ตรวจสอบโหมดธีมที่ใช้งาน
    final authController = Get.put(LoginController());
    final profileController = Get.find<ProfileController>(); // ดึง ProfileController มาใช้

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whisperGray, // ใช้สีพื้นฐานในโหมดปกติ
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppTextColors.secondary,
          ), // ปุ่มย้อนกลับ
          onPressed: () => Get.back(), // ใช้ GetX สำหรับย้อนกลับ
        ),
        title: Text(
          "ลบบัญชี",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                color: AppColors.gray,
                fontWeight: FontWeight.w600,
              ), // ปรับสีตามธีมที่ใช้งาน
        ),
        centerTitle: false, // ย้าย title ไปทางซ้าย
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "โปรดทราบ! เมื่อคุณลบบัญชี",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 18,
                            color: AppColors.primary,
                            // color: Colors.red,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(children: [
                        MyText("ข้อมูลทั้งหมดของคุณจะถูกลบถาวร ข้อมูลส่วนตัว เช่น ชื่อผู้ใช้ อีเมล เบอร์โทรศัพท์ รวมถึงประวัติการใช้งานจะถูกลบออกจากระบบโดยไม่สามารถกู้คืนได้",
                            context),
                        MyText("คุณจะไม่สามารถกู้คืนบัญชีนี้ได้ เมื่อลบบัญชีแล้ว คุณจะไม่สามารถลงชื่อเข้าใช้บัญชีเดิมได้อีก หากต้องการใช้บริการใหม่ จะต้องสมัครบัญชีใหม่เท่านั้น",
                            context),
                        MyText(
                            "การเข้าถึงบริการต่าง ๆ จะถูกยกเลิกฃ คุณจะไม่สามารถใช้ฟีเจอร์ที่ต้องใช้บัญชีของคุณ เช่น การบันทึกข้อมูล การซิงค์ข้อมูลระหว่างอุปกรณ์ หรือสิทธิ์การเข้าถึงเนื้อหาพิเศษได้อีกต่อไป",
                            context),
                      ]),
                    ),
                    Gap(10),
                    MyCheckBox(
                      text: "ฉันอ่านและเข้าใจถึงการลบบัญชีจะทำให้ข้อมูลทั้งหมดข้อคุณหายไปและไม่สามารถกู้คืนได้",
                      check: checkbox1,
                      onChanged: (value) {
                        setState(() {
                          checkbox1 = !checkbox1;
                        });
                      },
                      context: context,
                    ),
                    MyCheckBox(
                      text: "ฉันต้องการลบบัญชีของฉัน",
                      check: checkbox2,
                      context: context,
                      onChanged: (value) {
                        setState(() {
                          checkbox2 = value ?? false; // ป้องกัน null error
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ), // Spacer ที่จะผลักดันปุ่มไปอยู่ที่ด้านล่าง

          // ปุ่มยืนยันลบและยกเลิก
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                // gradient: AppGradiant.gradientX_1,
                color: Colors.white,
                border: const Border(
                  top: BorderSide(width: 1, color: AppTextColors.secondary), // ✅ เส้นขอบเฉพาะด้านบน
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ปุ่มยกเลิก
                    Expanded(
                      child: RimpaButton(
                        text: 'ยกเลิก',
                        radius: 32,
                        onTap: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 10), // เว้นระยะห่างระหว่างปุ่ม
                    // ปุ่มยืนยันลบ
                    Expanded(
                      child: GradiantButton(
                        text: 'ลบ',
                        radius: 32,
                        gradient: AppGradiant.redGradientX_1,
                        disble: !(checkbox1 && checkbox2),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteConfirmationPage(
                                onConfirmDelete: () {
                                  profileController.deleteUser(); // เรียก deleteUser() เมื่อกดตกลง
                                  Navigator.pop(context); // ปิดหน้ายืนยันหลังลบ
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

Widget MyText(String text, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTextColors.secondary,
          ),
        ),
      ),
      Gap(10),
      Expanded(
          child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: AppTextColors.secondary,
              fontWeight: FontWeight.w600,
            ),
        strutStyle: StrutStyle(
          leading: 0.8,
        ),
      )),
    ],
  );
}

Widget MyCheckBox({
  required String text,
  required bool check,
  required BuildContext context,
  required ValueChanged<bool?> onChanged,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Checkbox(
        value: check,
        onChanged: (value) => onChanged(value ?? false), // ป้องกัน null
        activeColor: Colors.red, // สีตอนถูกเลือก
        checkColor: AppColors.white, // สีของเครื่องหมายถูก
        side: const BorderSide(width: 2, color: AppColors.secondary),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppTextColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
            strutStyle: const StrutStyle(
              height: 1.5, // เพิ่มค่า height เพื่อให้ `leading` ทำงานถูกต้อง
              leading: 0.8,
            ),
          ),
        ),
      ),
    ],
  );
}
