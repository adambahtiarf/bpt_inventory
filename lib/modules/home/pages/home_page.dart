import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/button/button.dart';
import '../../../components/text/text.dart';
import '../../auth/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Scaffold(
      appBar: AppBar(title: AppText.google(text: "Welcome ${authController.user.value != null ? authController.user.value!.email : ''}")),
      body: AppButton.fill(
        text: "LOG OUT",
        onPressed: authController.logout,
      ),
    );
  }
}
