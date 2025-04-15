import 'package:get/get.dart';

import '../../asset/controllers/asset_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../transaction/controllers/transaction_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AssetController>(() => AssetController());
    Get.lazyPut<TransactionController>(() => TransactionController());
  }
}
