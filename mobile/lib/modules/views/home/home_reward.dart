import 'package:flutter/material.dart';

class HomeRewardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  "Username",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            Icon(Icons.notifications_none, color: Colors.black),
          ],
        ),
      ),
      body: Center(
        child: Text("รีวอร์ด"),
      ),
    );
  }
}
