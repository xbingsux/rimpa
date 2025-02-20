import 'package:get/get.dart';

class UserModel {
  var id = 0.obs;
  var email = ''.obs;
  var password = ''.obs;
  var roleId = 0.obs; // id ของ Role
  var role = ''.obs; // ชื่อ Role
  var createdAt = DateTime.now().obs;
  var updatedAt = DateTime.now().obs;
  var active = true.obs;

  get confirmPassword => null;
}

class ProfileModel {
  var id = 0.obs;
  var userId = 0.obs; // Foreign Key ไปยัง User
  var title = ''.obs; // คำนำหน้า
  var firstName = ''.obs;
  var lastName = ''.obs;
  var contactEmail = ''.obs;
  var birthDate = DateTime.now().obs;
  var phone = ''.obs;
  var profileImg = ''.obs;
  var profileName = ''.obs;
  var gender = ''.obs; // Gender
  var points = 0.0.obs;
  var idCard = ''.obs; // เลขบัตรประชาชน
  var createdAt = DateTime.now().obs;
  var updatedAt = DateTime.now().obs;
  var active = true.obs;
}
