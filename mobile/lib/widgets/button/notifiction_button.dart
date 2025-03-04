import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/views/notify/notify.view.dart';

class NotificationButton extends StatelessWidget {
  final double size;
  const NotificationButton({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Colors.amber,
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotifyView(),
            )),
        child: Container(
          decoration: const BoxDecoration(),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: const Center(
            child: Icon(Icons.notifications_none, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
