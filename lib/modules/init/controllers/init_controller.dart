import 'package:get/get.dart';

import '../../../core/utils/permission_util.dart';
import '../../../core/utils/storage_util.dart';

class InitController extends GetxController {
  var loading = false.obs;
  var isTokenAvailable = false.obs;
  var isLocationGranted = false.obs;
  var isCameraGranted = false.obs;

  Future<void> checkToken() async {
    String? token = await StorageUtil.getToken();
    isTokenAvailable.value = token != null && token.isNotEmpty;
  }

  Future<void> checkLocationPermission() async {
    isLocationGranted.value = await PermissionUtil.getLocationPermission();
  }

  Future<void> checkCameraPermission() async {
    isCameraGranted.value = await PermissionUtil.getCameraPermission();
  }

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    loading.value = true;
    await checkToken();
    await checkLocationPermission();
    await checkCameraPermission();
    loading.value = false;
  }
}
