import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/utils/app_util.dart';
import '../button/button.dart';
import '../icon/icon.dart';

class AppHeader {
  static PreferredSizeWidget global({
    void Function()? leadingFunction,
    Widget? drawerBuilder,
    IconData? leadingIcon,
    List<Widget>? actions,
    bool isDark = false,
    bool? centerTitle,
    Widget? title,
  }) =>
      PreferredSize(
        preferredSize: AppUtil.appBarPS(),
        child: AppBar(
          leadingWidth: drawerBuilder != null || leadingFunction != null ? AppUtil.appBarLW() : 0,
          titleSpacing: title != null ? AppUtil.appBarTS() : null,
          centerTitle: title != null ? centerTitle : null,
          backgroundColor: isDark ? AppColor.black : null,
          automaticallyImplyLeading: false,
          leading: drawerBuilder ??
              (leadingFunction != null
                  ? AppButton.icon(
                      iconColor: isDark ? AppColor.white : AppColor.black1C1C1C,
                      iconData: leadingIcon ?? AppIcon.arrowBackRounded(),
                      onPressed: leadingFunction,
                      iconButtonSize: 20.sp,
                    )
                  : null),
          titleTextStyle: isDark
              ? TextStyle(
                  color: AppColor.white,
                )
              : null,
          actions: actions,
          title: title,
        ),
      );
}
