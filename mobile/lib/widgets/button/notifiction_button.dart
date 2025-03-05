import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/views/notify/notify.view.dart';

class NotificationButton extends StatelessWidget {
  final double size;
  final bool isDark;
  const NotificationButton({super.key, this.size = 40, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      // color: Colors.amber,
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotifyView(),
            )),
        child: Container(
          decoration: const BoxDecoration(),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Center(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(Icons.notifications_none, size: size / 1.5, color: isDark ? Colors.white : Colors.grey),
                redDotNotification(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget redDotNotification({double size = 12, String? text}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.red,
    ),
    child: const Center(
      child: Text(
        "N",
        style: TextStyle(color: Colors.white, fontSize: 8),
      ),
    ),
  );
}
