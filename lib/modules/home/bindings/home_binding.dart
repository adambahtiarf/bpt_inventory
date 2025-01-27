import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
