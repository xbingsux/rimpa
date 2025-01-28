import 'package:get/get.dart';

class RegisterController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
 
  void register() {
    // ใส่ลอจิกการลงทะเบียนที่นี่ (เช่น API call หรือการตรวจสอบข้อมูล)
    if (email.isNotEmpty && password.isNotEmpty) {
      // สมมุติว่าเรียก API เพื่อทำการลงทะเบียน
      print("Registering with Email: $email and Password: $password");
      // สามารถเชื่อมโยงไปหน้าอื่นหลังการลงทะเบียนได้
      Get.snackbar("Success", "Account Created Successfully");
      Get.offAllNamed('/login'); // ไปหน้า login
    } else {
      // ถ้าข้อมูลไม่ครบ
      Get.snackbar("Error", "Please fill all fields");
    }
  }
} 
