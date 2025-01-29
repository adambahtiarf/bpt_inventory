import 'package:get/get.dart';

import '../../../components/dialog/dialog.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find();
  void handleSignout() {
    AppDialog.confirmation(
      context: Get.context!,
      title: 'Logout',
      description: 'Do you want to signing out?',
      yesFunc: () {
        _authController.logout();
      },
      noFunc: () {},
    );
  }
}
