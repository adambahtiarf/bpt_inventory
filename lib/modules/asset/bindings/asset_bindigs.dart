import 'package:get/get.dart';

import '../controllers/asset_controller.dart';

class AssetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetController>(() => AssetController());
  }
}
