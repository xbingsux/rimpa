import 'package:get/get.dart';
import '../../modules/views/auth/login.view.dart';
import '../../modules/views/register/register.view.dart';
import '../../modules/views/home/home.view.dart';
class AppPages {
  static const initial = '/login';
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
  ];
}
 