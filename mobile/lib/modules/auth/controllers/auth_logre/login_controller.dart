import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
 
  void login() {
    if (email.value.isNotEmpty && password.value.isNotEmpty) {
      // Logic การเข้าสู่ระบบ
      Get.snackbar('Success', 'Logged in as ${email.value}');
    } else {
      Get.snackbar('Error', 'Please fill in all fields');
    }
  }
}
 