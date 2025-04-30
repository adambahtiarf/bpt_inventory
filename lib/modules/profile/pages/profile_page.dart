import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../components/button/button.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_enums.dart';
import '../../../core/utils/app_util.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController _profileController = Get.find();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blue0A1A48,
        title: AppText.google(text: "Profile", color: AppColor.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.sp,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.google(text: "Email", color: AppColor.grey6B6B6B, size: 10.sp),
                  SizedBox(
                    height: 5.sp,
                  ),
                  AppText.google(
                    text: "inventory@bpt.com",
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.google(text: "App Version", color: AppColor.grey6B6B6B, size: 10.sp),
                  SizedBox(
                    height: 5.sp,
                  ),
                  AppText.google(
                    text: "v1.0.0",
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColor.grey6B6B6B,
            ),
            SizedBox(
              width: AppUtil.getDeviceSize(
                event: DeviceSizeEvent.width,
                context: context,
              ),
              child: AppButton.fill(
                text: "Logout",
                buttonEvent: ButtonEvent.tertiary,
                onPressed: _profileController.handleSignout,
              ),
            )
          ],
        ),
      ),
    );
  }
}
