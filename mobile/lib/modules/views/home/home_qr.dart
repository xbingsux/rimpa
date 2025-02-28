import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'dart:io';
import 'package:rimpa/modules/controllers/events/list_event_controller.dart';
import 'package:rimpa/modules/controllers/profile/profile_controller.dart';

class HomeQRPage extends StatefulWidget {
  @override
  _HomeQRPageState createState() => _HomeQRPageState();
}

class _HomeQRPageState extends State<HomeQRPage> {
  String? scannedResult;
  ApiUrls apiUrls = Get.find();
  final profileController =
      Get.put(ProfileController()); // เพิ่ม ProfileController
  late final EventController
      eventController; // Define EventController as a late variable

  @override
  void initState() {
    super.initState();
    eventController =
        Get.put(EventController()); // Register EventController here

    // ดึง idProfile จาก ProfileController
    String? idProfile = profileController.profileData['id']?.toString();

    // ตรวจสอบว่า idProfile และ scannedResult ไม่เป็น null ก่อนเรียกฟังก์ชัน scanQRCode
    if (idProfile != null && scannedResult != null) {
      eventController.scanQRCode(idProfile, scannedResult!);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? idProfile = profileController.profileData['id']?.toString();
    return Scaffold(
      backgroundColor: const Color.fromARGB(120, 0, 0, 0).withOpacity(0.7),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: QRScannerClipper(),
              child: MobileScanner(
                onDetect: (capture) {
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
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 30),
                  onPressed: () => Get.back(),
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
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("เลือกจากแกลเลอรี่"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (scannedResult != null)
                  Text(
                    "ผลลัพธ์: $scannedResult",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
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
