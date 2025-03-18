import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class SortButton extends StatefulWidget {
  final Function(bool data) onChanged;
  final Border border;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final bool isDesc; // เปลี่ยนเป็น final

  const SortButton({
    super.key,
    required this.onChanged,
    this.border = const Border.fromBorderSide(BorderSide(width: 1, color: AppColors.dark)),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.sm)),
    this.backgroundColor = AppColors.background_main,
    this.textColor = AppTextColors.primary,
    this.width = 120,
    this.height = 32,
    this.isDesc = true, // ค่าเริ่มต้น
  });

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  late bool isDesc; // เก็บค่าของ isDesc ไว้ใน State

  @override
  void initState() {
    super.initState();
    isDesc = widget.isDesc; // ตั้งค่าเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDesc = !isDesc; // Toggle ค่า
        });
        widget.onChanged(isDesc); // ส่งค่าที่เปลี่ยนไปให้ parent
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Theme.of(context).brightness == Brightness.light ? Border.all(color: Colors.black26, width: 1) : null,
          borderRadius: widget.borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(8),
            SizedBox(
              width: 80,
              child: Center(
                child: Text(
                  isDesc ? "ใหม่ล่าสุด" : "เก่าที่สุด",
                  style: TextStyle(fontSize: AppTextSize.md),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: AppTextSize.lg,
                    color: isDesc ? Colors.grey : Colors.black, // ทำให้ชัดเจนขึ้น
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: AppTextSize.lg,
                    color: isDesc ? Colors.black : Colors.grey, // ทำให้ชัดเจนขึ้น
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
