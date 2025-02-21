import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeQRPage extends StatefulWidget {
  @override
  _HomeQRPageState createState() => _HomeQRPageState();
}

class _HomeQRPageState extends State<HomeQRPage> {
  String? scannedResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
              120, 0, 0, 0) // ใช้ alpha 120 เพื่อให้โปร่งใสกว่า
          .withOpacity(0.7), // ทำให้พื้นหลังมีความทึบขึ้น
      body: Stack(
        children: [
          // กล้องเต็มจอ
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

                    // แสดง Popup Dialog เมื่อสแกนได้
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
          // ปุ่มย้อนกลับ
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

          // หมายเหตุอยู่ใต้กล่อง
          Positioned(
            top: 550, // วางให้ต่ำกว่ากล่อง
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
          // ส่วนเลือกภาพจากแกลเลอรี่
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
                    backgroundColor: Colors.blueAccent, // ปรับสีปุ่ม
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // เพิ่มมุมโค้งของปุ่ม
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

      // ใช้ mobile_scanner เพื่อสแกน QR จากภาพ
      final MobileScanner scanner = MobileScanner(onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          setState(() {
            scannedResult = barcode.rawValue ?? "ไม่มีข้อมูล";
          });

          // แสดงผล QR Code ที่สแกนได้
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

      // สแกน QR จากไฟล์ภาพ
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

    // สร้างกรอบสี่เหลี่ยมที่มีมุมโค้ง
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
