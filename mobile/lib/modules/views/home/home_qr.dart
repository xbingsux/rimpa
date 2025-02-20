// HomeQRPage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/popupdialog/popupeventpoint_dialog.dart'; // นำเข้า CustomDialog

class HomeQRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Center(
          child: Text(
            "Scan QR Code",
            style: TextStyle(color: Color(0xFF1E54FD), fontSize: 18),
          ),
        ),
        actions: [
          Container(
            width: 48, // ทำให้ Title อยู่ตรงกลางพอดี
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showPopup(context);
          },
          child: Text("Show Popup"),
        ),
      ),
    );
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(context: context); // ใช้ CustomDialog ที่สร้างขึ้น
      },
    );
  }
}
