import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/utils/string_util.dart';
import '../text/text.dart';

class AppBadge {
  static Widget statusTicketCM({required String? status}) {
    if (status != null && status.isNotEmpty) {
      Color? color;
      switch (status) {
        case "ASSIGNMENT":
          color = AppColor.blue6889E5;
        case "ACCEPT":
          color = AppColor.blue17A2B8;
        case "ARRIVAL":
          color = AppColor.blue133490;
        case "HANDLING":
          color = AppColor.yellowFFC926;
        case "ON REVIEW":
          color = AppColor.coralFFB158;
        case "REJECTED":
          color = AppColor.redD81D1D;
        case "DONE":
          color = AppColor.green29A835;

        default:
          color = AppColor.grey2B2B2B;
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: AppText.google(textAlign: TextAlign.center, text: StringUtil.toTitleCase(status), color: AppColor.white, weight: FontWeight.w700, size: 10.sp),
      );
    }
    return const SizedBox();
  }

  static Widget statusAssetCM({required String? status}) {
    if (status != null && status.isNotEmpty) {
      Color? color;
      switch (status) {
        case "OPEN":
          color = AppColor.blue6889E5;
        case "ON PROGRESS":
          color = AppColor.coralFFB158;
        case "SUBMITED":
          color = AppColor.blue133490;
        case "REJECTED":
          color = AppColor.redD81D1D;
        case "DONE":
          color = AppColor.green29A835;
        default:
          color = AppColor.grey2B2B2B;
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: AppText.google(textAlign: TextAlign.center, text: status, color: AppColor.white, weight: FontWeight.w700, size: 10.sp),
      );
    }
    return const SizedBox();
  }
}
