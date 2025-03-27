import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      color: AppTextColors.secondary,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.8)),
        fixedSize: MaterialStateProperty.all(Size(30, 30)),
      ),
    );
  }
}

class MyBackButton2 extends StatelessWidget {
  const MyBackButton2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1), // พื้นหลังดำ 30%
            border: Border.all(color: Colors.white, width: 1), // ขอบสีขาว หนา 2
            // borderRadius: BorderRadius.circular(8), // มุมโค้งเล็กน้อย (ถ้าต้องการ)
            shape: BoxShape.circle,
          ),
        ),
        Icon(
          Icons.arrow_back,
          color: AppColors.white,
        ),
      ],
    );
  }
}
