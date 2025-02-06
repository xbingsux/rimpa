import 'package:flutter/material.dart';

class HomeQRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Center(
          child: Text(
            "Scan QR Code",
            style: TextStyle(color: Color(0xFF1E54FD), fontSize: 18),
          ),
        ),
        actions: [
          Container(
            width: 48, // To center the title properly
          ),
        ],
      ),
      body: Center(
        child: Text("QR Code Scanner"),
      ),
    );
  }
}
