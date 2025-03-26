
import 'dart:async';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/controllers/middleware/auth_middleware.dart';
import 'package:rimpa/modules/models/notification.model.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notifications = <NotificationItem>[].obs; // ✅ RxList ของ NotificationItem
  var isRead = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    Timer.periodic(Duration(seconds: 30), (timer) {
      // print("fetching notifications ${isRead.value}");
      fetchNotifications();
    });
  }

  Future<void> fetchNotifications() async {
    try {
      final AuthMiddleware _authMiddleware = Get.find<AuthMiddleware>();
      String? token = await _authMiddleware.getToken(); // ดึง Token

      if (token == null) {
        print("No token found");
        return;
      }

      final ApiUrls apiUrlsController = Get.find<ApiUrls>(); // ดึง URL API
      isLoading(true);
      var dio = Dio();

      var response = await dio.get(
        apiUrlsController.notiUrl.value, // URL ที่ดึงมาจาก ApiUrls
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = NotificationResponse.fromJson(response.data);
        notifications
            .assignAll(data.noti); // ✅ ต้องเป็น data.noti ไม่ใช่ data ทั้งหมด
      } else {
        Get.snackbar("Error", "Failed to fetch notifications");
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching notifications: $e");
    } finally {
      areAllNotificationsRead();
      isLoading(false);
    }
  }

  Future<void> readNoti(notiID) async {
    try {
      final AuthMiddleware _authMiddleware = Get.find<AuthMiddleware>();
      String? token = await _authMiddleware.getToken(); // ดึง Token

      if (token == null) {
        print("No token found");
        return;
      }

      final ApiUrls apiUrlsController = Get.find<ApiUrls>(); // ดึง URL API
      // isLoading(true);
      var dio = Dio();

      var response = await dio.put(
        apiUrlsController.readNotiUrl.value, // URL ที่ดึงมาจาก ApiUrls
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: {
          "id": notiID,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("success");

        // ✅ อัปเดตค่า `read` ของ Notification ที่อ่านแล้วใน Local
        int index = notifications.indexWhere((noti) => noti.id == notiID);
        if (index != -1) {
          notifications[index] = NotificationItem(
            id: notifications[index].id,
            title: notifications[index].title,
            message: notifications[index].message,
            type: notifications[index].type,
            read: true, // ✅ อัปเดตเป็น true
            delete: notifications[index].delete,
            createdAt: notifications[index].createdAt,
            notiRoomId: notifications[index].notiRoomId,
          );
          notifications.refresh();
        }
      } else {
        Get.snackbar("Error", "Failed to read notifications");
      }
    } catch (e) {
      Get.snackbar("Error", "Error read notifications: $e");
    } finally {
      // isLoading(false);
      areAllNotificationsRead();
    }
  }

  void areAllNotificationsRead() {
    // ถ้ามี NotificationItem ที่ยังไม่อ่าน (read == false) จะ return false
    isRead(!notifications.any((noti) => noti.read == false));
  }
}
