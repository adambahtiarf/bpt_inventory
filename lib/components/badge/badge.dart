import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/utils/string_util.dart';
import '../text/text.dart';

class AppBadge {
  static Widget assetStatus({required String? status, double size = 10.0}) {
    if (status != null && status.isNotEmpty) {
      Color? color;
      switch (status) {
        case "AVAILABLE":
          color = AppColor.green228C2C;
        case "CURRENTLY BORROWED":
          color = AppColor.blue0C5697;
        case "MAINTENANCE":
          color = AppColor.orangeEC6B0C;
        case "OBSOLATE":
          color = AppColor.redCF1322;
        default:
          color = AppColor.grey2B2B2B;
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        child: AppText.google(
          textAlign: TextAlign.center,
          text: StringUtil.toTitleCase(status),
          color: AppColor.white,
          size: size,
        ),
      );
    }
    return const SizedBox();
  }

  static Widget assetCondition({required String? status, double size = 10.0}) {
    if (status != null && status.isNotEmpty) {
      Color? color;
      switch (status) {
        case "NEW":
          color = AppColor.green228C2C;
        case "GOOD":
          color = AppColor.blue0C5697;
        case "REPAIR NEEDED":
          color = AppColor.orangeEC6B0C;
        case "BROKEN":
          color = AppColor.redCF1322;
        default:
          color = AppColor.grey2B2B2B;
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        child: AppText.google(
          textAlign: TextAlign.center,
          text: StringUtil.toTitleCase(status),
          color: AppColor.white,
          size: size,
        ),
      );
    }
    return const SizedBox();
  }

  static Widget assetCategory({required String? category, double size = 8.0}) {
    if (category != null && category.isNotEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 1.sp),
        decoration: BoxDecoration(border: Border.all(color: AppColor.orangeEC6B0C, width: 1.sp), borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        child: AppText.google(
          textAlign: TextAlign.center,
          text: category,
          color: AppColor.black,
          size: size,
        ),
      );
    }
    return const SizedBox();
  }

  static Widget assetBorrowable({required bool? borrowable, double size = 8.0}) {
    if (borrowable != null && borrowable == true) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 1.sp),
        decoration: BoxDecoration(border: Border.all(color: AppColor.green29A835, width: 1.sp), borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        child: AppText.google(
          textAlign: TextAlign.center,
          text: "Borrowable",
          color: AppColor.black,
          size: size,
        ),
      );
    }
    return const SizedBox();
  }
}
