import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/controllers/middleware/auth_middleware.dart';

class NotifyController extends GetxController {
  final GetConnect _getConnect = GetConnect();
  final AuthMiddleware _authMiddleware = Get.put(AuthMiddleware());

  var notifications = [].obs;
  var notifications_loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(); // โหลดข้อมูลทันทีที่ Controller ถูกเรียกใช้
  }

  Future<void> fetchNotifications() async {
    try {
      String? _token = await _authMiddleware.getToken();
      notifications_loading.value = true;

      final response = await _getConnect.put( // ✅ ต้อง `await`
        "${AppApi.urlApi}/read-all-noti", // ✅ ใช้ตัวเดียวกันให้ตรง
        {},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 201) {
        var notiData = response.body["noti"];
        if (notiData != null) {
          notifications.assignAll(notiData); // ✅ เช็กก่อนใส่ค่า
        } else {
          notifications.clear(); // ถ้าไม่มีข้อมูล ให้เคลียร์ list
        }
      } else {
        throw Exception("โหลดแจ้งเตือนล้มเหลว: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      Get.snackbar("Error", "โหลดแจ้งเตือนล้มเหลว 😭");
    } finally {
      notifications_loading.value = false;
    }
  }
}
