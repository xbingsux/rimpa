import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/getusercontroller/auth_service.dart';
import 'package:rimpa/modules/controllers/notification/socketNotification.controller.dart';
import 'package:rimpa/modules/views/notify/notify.view.dart';

class NotificationButton extends StatelessWidget {
  final double size;
  final bool isDark;
  NotificationButton({super.key, this.size = 40, this.isDark = false});
  // final SocketNotificationController socketController = Get.put(SocketNotificationController());

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    authService.checkLoginStatus();
    return Obx(() => authService.isLoggedIn.value
        ? Container(
            width: size,
            height: size,
            // color: Colors.amber,
            child: GestureDetector(
              onTap: () {
                // socketController.clearNotification();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotifyView(),
                    ));
              },
              child: Container(
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Icon(Icons.notifications_none, size: size / 1.5, color: isDark ? Colors.white : Colors.grey),
                      // if (socketController.hasNewNotification.value) redDotNotification(),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container());
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
