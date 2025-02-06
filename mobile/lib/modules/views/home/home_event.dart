import 'package:flutter/material.dart';

class HomeEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "กิจกรรม",
                style: TextStyle(color: Color(0xFF1E54FD), fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.notifications_none, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("กิจกkkkรรม"),
      ),
    );
  }
}
