import 'package:get/get.dart';
import '../modules/auth/views/login_register/login_view.dart';
import '../modules/auth/views/login_register/create_view.dart';

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
  ];
}
