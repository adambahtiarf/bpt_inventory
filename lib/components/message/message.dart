import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/utils/app_util.dart';
import '../../core/utils/snackbar_util.dart';
import '../../data/type/message_params.dart';
import '../text/text.dart';

class AppMessage {
  static void snackBar(MessageParams params) {
    if (params.message.trim().isNotEmpty) {
      if (params.message.trim().length <= 92) {
        Color color = MessageUtil.getMessageColor(
          params: params,
        );

        ScaffoldMessenger.of(
          params.context,
        ).clearSnackBars();

        ScaffoldMessenger.of(
          params.context,
        ).showSnackBar(
          SnackBar(
            closeIconColor: AppUtil.isMobile ? AppColor.white : null,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                4.sp,
              ),
            ),
            showCloseIcon: AppUtil.isMobile,
            padding: AppUtil.isTablet
                ? EdgeInsets.symmetric(
                    horizontal: 8.sp,
                  )
                : EdgeInsets.only(
                    left: 8.sp,
                  ),
            backgroundColor: color,
            content: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.sp,
              ),
              child: AppText.google(
                text: params.message.trim(),
                color: AppColor.white,
                maxLines: 2,
                size: 10.sp,
              ),
            ),
            elevation: 0,
          ),
        );
      }
    }
  }
}
