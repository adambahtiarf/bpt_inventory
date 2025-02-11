import '../modules/asset/bindings/asset_bindigs.dart';
import '../modules/asset/pages/asset_add_page.dart';
import '../modules/asset/pages/asset_detail_page.dart';
import '../modules/asset/pages/asset_edit_page.dart';
import '../modules/asset/pages/asset_qr_code_page.dart';
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
    GetPage(
      name: AppRoutes.assetDetail,
      page: () => const AssetDetailPage(),
      binding: AssetBinding(),
    ),
    GetPage(
      name: AppRoutes.assetQR,
      page: () => const AssetQrCodePage(),
      binding: AssetBinding(),
    ),
    GetPage(
      name: AppRoutes.assetAdd,
      page: () => const AssetAddPage(),
      binding: AssetBinding(),
    ),
    GetPage(
      name: AppRoutes.assetEdit,
      page: () => const AssetEditPage(),
      binding: AssetBinding(),
    ),
  ];
}
