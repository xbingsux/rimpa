import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/middleware/auth_middleware.dart';
import 'package:rimpa/modules/models/history/historypoint.model.dart';
import 'package:rimpa/modules/views/history/history.view.dart';

class HistoryController extends GetxController {
  final AuthMiddleware authMiddleware = AuthMiddleware();
  final GetConnect getConnect = GetConnect();

  Rx<HistoryType> activeType = HistoryType.all.obs;
  RxList<HistoryPointModel> historyPointList = <HistoryPointModel>[].obs;
  var isPointLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPointHistory();
  }

  void fetchPointHistory() async {
    try {
      String? token = await authMiddleware.getToken();
      if (token == null) {
        print("Token is null");
        return;
      }

      isPointLoading.value = true;
      String api = "${AppApi.urlApi}/auth/point-history";
      if (activeType.value == HistoryType.earn) {
        api = "$api?type=EARN";
      } else if (activeType.value == HistoryType.redeem) {
        api = "$api?type=REDEEM";
      } else {
        api = "$api?type";
      }

      final response = await getConnect.get(
        api,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var data = response.body;
        if (data != null && data['status'] == 'success') {
          if (data['history'] != null && data['history'] is List) {
            historyPointList.value = (data['history'] as List<dynamic>)
              .map((json) => HistoryPointModel.fromJson(json as Map<String, dynamic>))
              .toList();
          } else {
            historyPointList.clear(); // ถ้าไม่มีข้อมูล ให้ล้าง list
          }
        } else {
          print("Error: ${data['message']}");
        }
      } else {
        print("Failed to fetch history, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching history: $e");
    } finally {
      isPointLoading.value = false;
    }
  }
}
