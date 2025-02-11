import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/constants.dart';
import '../../core/utils/app_util.dart';
import '../button/button.dart';
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

  static Future<dynamic> confirmation({
    required BuildContext context,
    required String title,
    required String description,
    Function()? yesFunc,
    Function()? noFunc,
  }) {
    Widget child = AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        description,
        style: TextStyle(
          fontSize: 14.sp,
        ),
      ),
      actions: [
        AppButton.text(
          text: "No",
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            noFunc?.call();
          },
        ),
        AppButton.text(
          text: "Yes",
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            yesFunc?.call();
          },
        )
      ],
    );

    if (Platform.isAndroid) {
      return showDialog(
        barrierDismissible: false,
        builder: (_) => child,
        context: context,
      );
    }

    if (Platform.isIOS) {
      return showCupertinoDialog(
        barrierDismissible: false,
        builder: (_) => child,
        context: context,
      );
    }
    return Future.value();
  }

  static Future<dynamic> showImageDialog({
    required BuildContext context,
    required String imageUrl,
  }) {
    Widget child = Dialog(
      backgroundColor: Colors.transparent,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 50.sp),
      ),
    );

    return showDialog(
      context: context,
      builder: (_) => child,
    );
  }
}
