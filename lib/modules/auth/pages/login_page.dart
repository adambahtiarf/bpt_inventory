import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/button/button.dart';
import '../../../components/icon/icon.dart';
import '../../../components/input/input.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/app_util.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final emailTxtCtrl = TextEditingController();
  final passwordTxtCtrl = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.google(
              text: "Login",
              size: 18.sp,
              weight: FontWeight.bold,
            ),
            SizedBox(
              height: 20.sp,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 5.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.google(text: "Email"),
                  SizedBox(
                    height: 5.sp,
                  ),
                  AppInput.global(
                    txtCtrl: emailTxtCtrl,
                    prefixIcon: AppIcon.email(),
                    hintText: "Email ID",
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 5.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.google(text: "Password"),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Obx(
                    () => AppInput.global(
                      txtCtrl: passwordTxtCtrl,
                      obscure: authController.obsecurePasswordInput.value,
                      prefixIcon: AppIcon.lock(),
                      hintText: "Password",
                      suffixIcon: authController.obsecurePasswordInput.value ? AppIcon.visibilityOffOutline() : AppIcon.visibilityOutline(),
                      suffixFunc: () {
                        authController.obsecurePasswordInput.value = !authController.obsecurePasswordInput.value;
                      },
                      suffixColor: AppColor.orangeEC6B0C,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            SizedBox(
              width: AppUtil.getDeviceSize(event: DeviceSizeEvent.width, context: context),
              child: Obx(() => AppButton.fill(
                    text: !authController.loading.value ? "Login" : "Loading...",
                    buttonEvent: ButtonEvent.primary,
                    onPressed: !authController.loading.value ? () => authController.login(email: emailTxtCtrl.text, password: passwordTxtCtrl.text) : null,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
