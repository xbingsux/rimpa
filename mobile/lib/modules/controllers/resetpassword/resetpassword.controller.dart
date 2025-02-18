import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_urls.dart'; // นำเข้าที่เก็บ API URL

class ResetPasswordController extends GetxController {
  var isLoading = false.obs;
  var oldPassword = ''.obs; // Observable variable for old password
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;
  var token = ''.obs; // จะเก็บ token ที่ได้จากการส่งไปก่อนหน้า
  var message = ''.obs;
  var status = ''.obs;

  var isOldPasswordVisible = false.obs; // สำหรับการเปิด/ปิดมองเห็นรหัสผ่านเก่า
  var isNewPasswordVisible = false.obs; // สำหรับการเปิด/ปิดมองเห็นรหัสผ่านใหม่
  var isConfirmPasswordVisible = false.obs; // สำหรับการเปิด/ปิดมองเห็นรหัสผ่านยืนยัน

  final Dio dio = Dio();
  final apiUrlsController = Get.find<ApiUrls>(); // เรียก ApiUrls จาก GetX

  // ฟังก์ชันส่งคำขอรีเซ็ตรหัสผ่าน
  Future<void> resetPassword() async {
    isLoading.value = true;
    try {
      if (newPassword.value.isEmpty || confirmPassword.value.isEmpty) {
        message.value = 'กรุณากรอกรหัสผ่านใหม่และยืนยันรหัสผ่าน';
        isLoading.value = false;
        return;
      }

      if (newPassword.value != confirmPassword.value) {
        message.value = 'รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน';
        isLoading.value = false;
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        message.value = 'ไม่พบ Token';
        isLoading.value = false;
        return;
      }

      var response = await dio.post(
        apiUrlsController.resetPassword.value,
        data: {
          "token": token,
          "new_password": newPassword.value,
        },
      );

      if (response.statusCode == 200) {
        status.value = "success";
        message.value = "รีเซ็ตรหัสผ่านสำเร็จ";
      } else {
        status.value = "error";
        message.value = "ไม่สามารถรีเซ็ตรหัสผ่านได้";
      }
    } catch (e) {
      status.value = "error";
      message.value = "เกิดข้อผิดพลาดในการรีเซ็ตรหัสผ่าน";
    } finally {
      isLoading.value = false;
    }
  }
}
