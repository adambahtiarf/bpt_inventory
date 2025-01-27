import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/constants.dart';
import '../../core/utils/app_util.dart';
import '../spinner/spinner.dart';

class AppDialog {
  static Future<dynamic>? spinner({
    required BuildContext context,
  }) {
    Widget child = PopScope(
      canPop: Constants.kCannotPop,
      child: Center(
        child: CircleAvatar(
          backgroundColor: AppColor.white,
          radius: 20.sp,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  100.sp,
                ),
              ),
              color: AppColor.white,
            ),
            padding: EdgeInsets.all(
              10.sp,
            ),
            child: Spinner.popUp(
              height: AppUtil.isTablet ? 70.sp : 60.sp,
              width: AppUtil.isTablet ? 70.sp : 60.sp,
            ),
          ),
        ),
      ),
    );

    if (Platform.isAndroid) {
      showDialog(
        barrierDismissible: false,
        builder: (_) => child,
        context: context,
      );
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        builder: (_) => child,
        context: context,
      );
    }

    return null;
  }
}
