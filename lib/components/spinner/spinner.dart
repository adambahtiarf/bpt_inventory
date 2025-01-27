import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/utils/app_util.dart';
import '../blank/blank.dart';
import '../text/text.dart';

class Spinner {
  static Widget popUp({
    required double height,
    required double width,
  }) =>
      SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 3.sp,
        ),
      );

  static Widget page({
    String? processDesc,
  }) {
    Widget spinnerWidget = const Blank();

    if (Platform.isAndroid) {
      spinnerWidget = CircularProgressIndicator(
        strokeWidth: 3.9.sp,
      );
    }

    if (Platform.isIOS) {
      spinnerWidget = Transform.scale(
        scale: AppUtil.isTablet ? 0.95.sp : 1.9.sp,
        child: const CupertinoActivityIndicator(),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (spinnerWidget is! Blank)
            SizedBox(
              height: 30.sp,
              width: 30.sp,
              child: spinnerWidget,
            ),
          if (processDesc != null && processDesc.trim().isNotEmpty)
            Padding(
              padding: spinnerWidget is! Blank
                  ? EdgeInsets.only(
                      top: 11.sp,
                    )
                  : EdgeInsets.zero,
              child: AppText.google(
                textAlign: TextAlign.center,
                text: processDesc.trim(),
                size: 14.sp,
              ),
            )
        ],
      ),
    );
  }
}
