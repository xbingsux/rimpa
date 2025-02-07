import 'package:get/get.dart';

class ApiUrls extends GetxController {
  // baseUrl สามารถเปลี่ยนแปลงได้ตามต้องการ
  var baseUrl = 'http://192.168.1.2:3001/auth'.obs;

  // ฟังก์ชันที่ใช้ในการอัปเดต baseUrl
  void updateBaseUrl(String newUrl) {
    baseUrl.value = newUrl;
  }

  // คำนวณ URL ของ login และ register โดยใช้ baseUrl ที่อัปเดต
  String get login => '${baseUrl.value}/login';
  String get register => '${baseUrl.value}/register';
}
