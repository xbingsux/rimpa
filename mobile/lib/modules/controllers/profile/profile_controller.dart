import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_urls.dart'; // นำเข้าที่เก็บ API URL

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = {}.obs;

  final Dio dio = Dio();
  final apiUrlsController = Get.find<ApiUrls>(); // เรียก ApiUrls จาก GetX

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token =
          prefs.getString("token"); // ดึง token จาก SharedPreferences

      if (token == null) {
        isLoading.value = false;
        return;
      }
      print("Token: $token");
      var response = await dio.post(
        apiUrlsController.profileMe, // ดึง URL จาก ApiUrls
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        profileData.value = response.data["profile"];
      } else {
        print("Failed to fetch profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }
}
