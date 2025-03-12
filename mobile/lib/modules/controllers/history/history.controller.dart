import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/middleware/auth_middleware.dart';
import 'package:rimpa/modules/models/history/historypoint.model.dart';
import 'package:rimpa/modules/views/history/history.view.dart';

class HistoryController extends GetxController {
  final AuthMiddleware authMiddleware = AuthMiddleware();
  final GetConnect getConnect = GetConnect();

  Rx<HistoryType> activeType = HistoryType.all.obs;
  RxList<HistoryPointModels> historyPointList = <HistoryPointModels>[].obs;
  var historyList = <dynamic>[].obs;
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

      final response = await getConnect.get(
        "${AppApi.urlApi}/auth/get-noti",
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var data = response.body;
        if (data != null && data['status'] == 'success') {
          // print(List.from(data['noti']));
          //   List.from(data['noti']).map((item){
          //     print(item);
          //     // historyPointList.add(HistoryPointModels.fromJson(item));
          //   });
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
