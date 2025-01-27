import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/message/message.dart';
import '../../data/type/message_params.dart';
import '../constant/app_enums.dart';
import 'error_mapper_utils.dart';

class PermissionUtil {
  static Future<bool> getLocationPermission() async {
    final status = await Permission.location.request();
    return _handlePermissionStatus(status, ImplEvent.getAccessLocation);
  }

  static Future<bool> getCameraPermission() async {
    final status = await Permission.camera.request();
    return _handlePermissionStatus(status, ImplEvent.getAccessCamera);
  }

  static bool _handlePermissionStatus(PermissionStatus status, ImplEvent event) {
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      MessageParams errMessage = (
        message: ErrorMapperUtils.errMessage(implEvent: event),
        messageEvent: MessageEvent.error,
        context: Get.context!,
      );
      AppMessage.snackBar(errMessage);
    }
    return false;
  }
}
