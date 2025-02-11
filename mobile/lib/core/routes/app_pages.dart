import 'package:get/get.dart';
import '../../modules/views/auth/login.view.dart';
import '../../modules/views/register/register.view.dart';
import '../../modules/views/home/home.view.dart';
import '../../modules/views/selectregister/selectregister.view.dart';
import '../../modules/views/forgotpasswords/forgotpassworduser.dart';
import '../../modules/views/profile/userdetail/user_detail.dart';
import '../../modules/views/profile/changpassword/chang_password.dart';
import '../../modules/views/profile/deleteaccount/delete_account.dart';
class AppPages {
  static const initial = '/home';
  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginView(),
    ),
     GetPage(
      name: '/create-account',
      page: () => CreateAccountView(),
    ),
    GetPage(
      name: '/home',
      page: () => HomePage(),
    ),
    GetPage(
      name: '/select-create',
      page: () => LoginSelectionView(),
    ),
    GetPage(
      name: '/forgot-password',
      page: () => ForgotPasswordView(),
    ),




    // Profile routes detail
    GetPage(
      name: '/user-deteil',
      page: () => UserDetail(),
    ),
    GetPage(
      name: '/chang-password',
      page: () => ChangePassword(),
    ),
    GetPage(
      name: '/delete-account',
      page: () => UserDetail(),
    ),

  ];
}
 