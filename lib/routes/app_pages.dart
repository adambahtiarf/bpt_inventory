import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/pages/home_page.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/pages/profile_page.dart';
import 'app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
  ];
}
