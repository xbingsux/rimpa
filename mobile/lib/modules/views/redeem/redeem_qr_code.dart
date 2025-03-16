import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/core/services/date_format.dart';
import 'package:rimpa/widgets/button/back_button.dart';
import 'package:rimpa/widgets/button/botton.dart';
import 'package:rimpa/widgets/card/countdown.dart';
import 'package:rimpa/widgets/popupdialog/popupeventpoint_dialog.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class ReddemQRcode extends StatefulWidget {
  const ReddemQRcode({super.key});

  @override
  State<ReddemQRcode> createState() => _ReddemQRcodeState();
}

class _ReddemQRcodeState extends State<ReddemQRcode> {
  String createDate = thDateFormat(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // กว้างเต็มจอ
        height: double.infinity, // สูงเต็มจอ
        decoration: const BoxDecoration(gradient: AppGradiant.gradientY_1),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false, // ป้องกันกดข้างนอกเพื่อปิด
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: AppColors.white,
                                icon: Icon(
                                  Iconsax.danger,
                                  color: AppColors.danger,
                                  size: 50,
                                ),
                                title: Center(
                                  child: Text(
                                    "ต้องการออกจากหน้านี้",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 20,
                                          color: AppColors.danger,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "หากออกจากหน้านี้ สิทธิ์คูปองของคุณอาจไม่ได้รับการบันทึก คุณต้องการออกจากหน้านี้หรือไม่? กรุณาตรวจสอบสิทธิ์คูปองก่อนออก",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, color: AppTextColors.secondary, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(children: [
                                    Expanded(
                                      child: RimpaButton(
                                        text: 'อยู่ในหน้านี้',
                                        radius: 32,
                                        disble: false,
                                        onTap: () => Get.back(),
                                      ),
                                    ),
                                    const SizedBox(width: 10), // เว้นระยะห่างระหว่างปุ่ม
                                    // ปุ่มยืนยันลบ
                                    Expanded(
                                      child: GradiantButton(
                                        text: 'ออกจากหน้านี้',
                                        radius: 32,
                                        onTap: () {
                                          Get.back();
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ])
                                ],
                              );
                            },
                          );
                        },
                        child: MyBackButton2()),
                    Text(
                      "แลกรับสิทธ์",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 20,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Gap(40),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      // ไม่มีขอบใน Dark Mode
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Gap(40),
                        Text(
                          "แลกรับสิทธ์",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 18,
                                color: AppTextColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Gap(20),
                        // Container(
                        //   width: 200,
                        //   height: 200,
                        //   color: Colors.grey,
                        // ),
                        Center(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: SfBarcodeGenerator(
                              showValue: true,
                              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    color: AppTextColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                              value: "cm7p228nf000as012aqbkb8e4",
                              symbology: QRCode(errorCorrectionLevel: ErrorCorrectionLevel.low),
                            ),
                          ),
                        ),

                        Gap(60),
                        CustomPaint(
                          size: Size(double.infinity, 1),
                          painter: DottedLinePainter(
                            color: Colors.grey,
                            dashWidth: 8,
                            dashSpace: 6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "วันที่แลกรับสิทธิ์",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 16,
                                          color: AppTextColors.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Text(
                                    "${createDate}",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 16,
                                          color: AppTextColors.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                              Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "หมดอายุใน",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 16,
                                          color: AppTextColors.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  // Text(
                                  //   "30:00",
                                  //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  //         fontSize: 16,
                                  //         color: AppTextColors.secondary,
                                  //         fontWeight: FontWeight.w500,
                                  //       ),
                                  // ),
                                  CountdownTimer(
                                    targetDateTime: DateTime(2024, 3, 16, 23, 59, 0),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
