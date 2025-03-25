import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/core/services/date_format.dart';
import 'package:rimpa/modules/views/redeem/redeem_qr_controller.dart';
import 'package:rimpa/widgets/button/back_button.dart';
import 'package:rimpa/widgets/button/botton.dart';
import 'package:rimpa/widgets/card/countdown.dart';
import 'package:rimpa/widgets/popupdialog/popupeventpoint_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
class ReddemQRcode extends StatelessWidget {
  final int rewardID;
  ReddemQRcode({super.key, required this.rewardID});
  final RedeemQRController controller = Get.put(RedeemQRController());

  Widget build(BuildContext context) {
    controller.fetchRedeemQR(rewardID); // โหลด API เมื่อเปิดหน้า

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                            barrierDismissible: false,
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
                                    "ต้องการออกจากหน้านี้?",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 20,
                                          color: AppColors.danger,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                content: Text(
                                  "หากออกจากหน้านี้ สิทธิ์คูปองของคุณอาจไม่ได้รับการบันทึก กรุณาตรวจสอบสิทธิ์คูปองก่อนออก",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 14,
                                        color: AppTextColors.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                    const SizedBox(width: 10),
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
                      "แลกรับสิทธิ์",
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
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 560,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    }

                    if (controller.errorMessage.value.isNotEmpty) {
                      return errorWidget(context);
                    }

                    final data = controller.redeemData.value;
                    if (data == null) {
                      return Center(child: Text("ไม่มีข้อมูล"));
                    }
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Gap(40),
                          Text(
                            "แลกรับสิทธิ์",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 18,
                                  color: AppTextColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Gap(20),
                          Center(
                            child: SizedBox(
                              height: 300,
                              width: 300,
                              child: SfBarcodeGenerator(
                                showValue: false,
                                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      color: AppTextColors.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                value: data.token,
                                symbology: QRCode(errorCorrectionLevel: ErrorCorrectionLevel.low),
                                
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(data.token, maxLines: 2,style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700,)),
                          ),
                          Gap(40),
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
                                    Text("วันที่แลกรับสิทธิ์"),
                                    Text(thDateFormat(data.issuedAt)),
                                  ],
                                ),
                                Gap(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("หมดอายุใน"),
                                    CountdownTimer(targetDateTime: data.expiresAt),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget errorWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(40),
          Text(
            "แลกรับสิทธิ์",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  color: AppTextColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Gap(20),
          GestureDetector(
            onTap: () => controller.fetchRedeemQR(rewardID),
            child: Center(
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.refresh,
                    size: 50,
                    color: AppTextColors.secondary,
                  ),
                ),
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
                    Text("วันที่แลกรับสิทธิ์"),
                    Text("XX XXXX XXXX"),
                  ],
                ),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("หมดอายุใน"),
                    Text("XX:XX"),
                    // CountdownTimer(targetDateTime: data.expiresAt),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
