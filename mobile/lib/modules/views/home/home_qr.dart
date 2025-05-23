import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/core/services/api_service.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'dart:io';
import 'package:rimpa/modules/controllers/events/list_event_controller.dart';
import 'package:rimpa/modules/controllers/profile/profile_controller.dart';
import 'package:rimpa/widgets/button/botton.dart';
import 'package:rimpa/widgets/popupdialog/popupeventpoint_dialog.dart';

class HomeQRPage extends StatefulWidget {
  @override
  _HomeQRPageState createState() => _HomeQRPageState();
}

class _HomeQRPageState extends State<HomeQRPage> with WidgetsBindingObserver {
  String? scannedResult;
  ApiUrls apiUrls = Get.find();
  final profileController = Get.put(ProfileController()); // เพิ่ม ProfileController
  late final EventController eventController; // Define EventController as a late variable
  bool isProcessing = false;
  late MobileScannerController scannerController;
  @override
  void initState() {
    super.initState();
    eventController = Get.put(EventController()); // Register EventController here
    scannerController = MobileScannerController();
    WidgetsBinding.instance.addObserver(this);
    // ดึง idProfile จาก ProfileController
    String? idProfile = profileController.profileData['id']?.toString();
    // ตรวจสอบว่า idProfile และ scannedResult ไม่เป็น null ก่อนเรียกฟังก์ชัน scanQRCode
    if (idProfile != null && scannedResult != null) {
      eventController.scanQRCode(idProfile, scannedResult!);
    }
  }

  void dispose() {
    scannerController.dispose(); // ปิดกล้องเมื่อออกจากหน้านี้
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      scannerController.stop(); // หยุดกล้องเมื่อไปแอปอื่น
    } else if (state == AppLifecycleState.resumed) {
      scannerController.start(); // เริ่มกล้องใหม่เมื่อกลับมา
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(120, 0, 0, 0).withOpacity(0.7),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: QRScannerClipper(),
              child: MobileScanner(
                controller: scannerController,
                onDetect: (capture) async {
                  if (isProcessing) return; // ป้องกันการยิงซ้ำ

                  isProcessing = true; // กำลังประมวลผล
                  EasyLoading.show(status: 'กำลังประมวลผล...');

                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    String scannedData = barcode.rawValue ?? "ไม่มีข้อมูล";
                    print(scannedData.toString());
                    try {
                      final response = await ApiService().post("/event/checkIn", data: {
                        "qrcode": scannedData,
                      });

                      EasyLoading.dismiss(); // ปิด loading
                      print("=========> statusCode : ${response?.statusCode}");
                      if (response?.statusCode == 201) {
                        Navigator.pop(context);
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(context: context, point: response?.data['event']['points'], total: response?.data['event']['Profile']['points']);
                          },
                        );
                      } else {
                        await showErrorDialog(title: response?.data['status'], detail: response?.data['message']);
                      }
                    } catch (e) {
                      print(e.toString());
                      EasyLoading.dismiss();
                      await showErrorDialog();
                    }

                    isProcessing = false; // ปลดล็อกให้สแกนใหม่ได้
                    break; // ออกจาก loop หลังจากยิง API
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    scannerController.dispose();
                    Get.back();
                  },
                ),
                const Text(
                  'ย้อนกลับ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 550,
            left: 20,
            right: 20,
            child: Text(
              "ควรวาง QR Code ให้อยู่ในช่องที่กำหนดด้านบนเพื่อให้สามารถสแกนได้",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Positioned(
          //   bottom: 100,
          //   left: 20,
          //   right: 20,
          //   child: Column(
          //     children: [
          //       ElevatedButton.icon(
          //         onPressed: _pickImage,
          //         icon: const Icon(Icons.image),
          //         label: const Text("เลือกจากแกลเลอรี่"),
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Colors.blueAccent,
          //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(height: 20),
          //       if (scannedResult != null)
          //         Text(
          //           "ผลลัพธ์: $scannedResult",
          //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> showErrorDialog({String title = "เกิดข้อผิดพลาด", String detail = "เกิดข้อผิดพลาดไม่ทราบสาเหตุ"}) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันกดข้างนอกเพื่อปิด
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Iconsax.danger,
            color: AppColors.danger,
            size: 40,
          ),
          backgroundColor: AppColors.white,
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 20,
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
          ),
          content: Text(
            detail,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                ),
          ),
          actions: [
            Center(
              child: RimpaButton(
                text: 'รับทราบ',
                radius: 32,
                disble: false,
                onTap: () => Navigator.pop(
                  context,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String imagePath = image.path;

      final MobileScanner scanner = MobileScanner(onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          setState(() {
            scannedResult = barcode.rawValue ?? "ไม่มีข้อมูล";
          });

          eventController.scanQRCode('idProfile', scannedResult!);

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("ผลลัพธ์ QR Code"),
                content: Text(scannedResult!),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ปิด"),
                  ),
                ],
              );
            },
          );
        }
      });

      final result = await scanner.scanImage(File(imagePath));

      if (result != null) {
        setState(() {
          scannedResult = result.rawValue ?? "ไม่มีข้อมูล";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ไม่พบ QR Code ในภาพ")),
        );
      }
    }
  }
}

extension on MobileScanner {
  scanImage(File file) {}
}

class QRScannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(30, 180, size.width - 60, 350),
      Radius.circular(20),
    ));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
