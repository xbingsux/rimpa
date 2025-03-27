import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class Policy extends StatelessWidget {
  const Policy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "นโยบายความเป็นส่วนตัว",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTextColors.black,
            ),
        ),
        iconTheme: const IconThemeData(color: AppTextColors.secondary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: const [
          Section(
            title: "1. บทนำ",
            content:
                "แอปพลิเคชันให้ความสำคัญกับความเป็นส่วนตัวของผู้ใช้ เรามุ่งเน้นที่จะปกป้องข้อมูลส่วนบุคคลของคุณ "
                "เราอธิบายถึงวิธีที่เราเก็บรวบรวม ใช้ เปิดเผย และปกป้องข้อมูลของคุณเพื่อใช้ในแอปของเรา",
          ),
          Section(
            title: "2. ข้อมูลที่เราเก็บรวบรวม",
            content: "เมื่อคุณใช้แอป เราอาจเก็บข้อมูลต่อไปนี้:\n"
                "       • ข้อมูลส่วนตัว: ชื่อผู้ใช้ อีเมล หมายเลขโทรศัพท์\n"
                "       • ข้อมูลการกระทำ: ประวัติการกระทำและแลกแต้ม\n"
                "       • ข้อมูลตำแหน่งที่ตั้ง เพื่อให้บริการที่เกี่ยวข้องกับสถานที่",
          ),
          Section(
            title: "3. วิธีการใช้ข้อมูล",
            content: "เราใช้ข้อมูลของคุณเพื่อ:\n"
                "       • จัดการบัญชีและให้บริการสะสมแต้ม\n"
                "       • ปรับปรุงประสบการณ์การใช้งานแอปฯ\n"
                "       • แจ้งเตือนเกี่ยวกับโปรโมชั่นและสิทธิพิเศษ",
          ),
          Section(
            title: "4. การรักษาความปลอดภัยของข้อมูล",
            content:
                "เราดำเนินการรักษาความปลอดภัยที่เหมาะสมเพื่อป้องกันการเข้าถึงหรือเปิดเผยข้อมูลโดยไม่ได้รับอนุญาต",
          ),
          Section(
            title: "5. สิทธิของผู้ใช้",
            content:
                "คุณมีสิทธิในการเข้าถึง แก้ไขหรือลบข้อมูลส่วนบุคคลของคุณ สามารถติดต่อเรา",
          ),
          Section(
            title: "6. การเปลี่ยนแปลงนโยบาย",
            content:
                "เราขอสงวนสิทธิ์ในการเปลี่ยนแปลงนโยบายนี้ กรุณาตรวจสอบการเปลี่ยนแปลงบนแอปฯของเรา",
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String content;

  const Section({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: AppTextSize.md,
                  fontWeight: FontWeight.w600,
                  color: AppTextColors.primary.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: AppTextSize.md,
                  fontWeight: FontWeight.w500,
                  color: AppTextColors.secondary,
                ),
          ),
        ],
      ),
    );
  }
}
