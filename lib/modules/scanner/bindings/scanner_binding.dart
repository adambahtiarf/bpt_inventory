import 'package:get/get.dart';

import '../../_sample/controllers/sample_controller.dart';

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SampleController>(() => SampleController());
  }
}
