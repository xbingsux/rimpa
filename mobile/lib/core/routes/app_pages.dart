import 'package:get/get.dart';
import '../../modules/views/auth/login.view.dart';
import '../../modules/views/register/register.view.dart';
import '../../modules/views/home/home.view.dart';
import '../../modules/views/selectregister/selectregister.view.dart';
import '../../modules/views/forgotpasswords/forgotpassworduser.dart';
import '../../modules/views/profile/userdetail/user_detail.dart';
import '../../modules/views/profile/changpassword/chang_password.dart';
import '../../modules/views/profile/deleteaccount/delete_account.dart';
import '../../modules/views/home/banners/bannersd_detail.dart';
class AppPages {
  static const initial = '/home';  // หน้าเริ่มต้นที่แอปเปิดขึ้นมา
  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginView(),
      transition: Transition.fade,  // เลือก transition ที่ต้องการ
      transitionDuration: Duration(milliseconds: 500),  // ใช้ transitionDuration แทน duration
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
      page: () => DeleteAccount(),
    ),

    // bannerdetail
    GetPage(
      name: '/detail-banner',
      page: () => BannersDetailPage(),
    ),
  ];
}
