import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/controllers/middleware/auth_middleware.dart';
import 'package:rimpa/modules/models/notification.model.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notifications = <NotificationItem>[].obs; // ✅ RxList ของ NotificationItem

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
        notifications.assignAll(data.noti); // ✅ ต้องเป็น data.noti ไม่ใช่ data ทั้งหมด
      } else {
        Get.snackbar("Error", "Failed to fetch notifications");
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }
}
