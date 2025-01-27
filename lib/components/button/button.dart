import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/app_enums.dart';
import '../../core/utils/app_util.dart';
import '../../core/utils/button_util.dart';
import '../text/text.dart';

class AppButton {
  static IconButton icon({
    required void Function()? onPressed,
    EdgeInsetsGeometry? buttonPadding,
    double? iconButtonSize,
    Widget? suffixWidget,
    IconData? iconData,
    Color? iconColor,
    bool? isSuffix,
  }) {
    EdgeInsetsGeometry? newButtonPadding = buttonPadding;

    double? newIconSize = iconButtonSize;

    if (isSuffix != null) {
      if (isSuffix) {
        if (AppUtil.isTablet) {
          newButtonPadding = EdgeInsets.symmetric(
            horizontal: 10.sp,
          );
        }

        newIconSize ??= 22.sp;
      }
    }

    return IconButton(
      padding: newButtonPadding,
      iconSize: newIconSize,
      icon: suffixWidget ??
          Icon(
            size: newIconSize,
            color: iconColor,
            iconData,
          ),
      onPressed: onPressed,
    );
  }

  static TextButton text({
    AlignmentGeometry? buttonAlignment,
    EdgeInsetsGeometry? iconMargin,
    Color? buttonBackgroundColor,
    void Function()? onPressed,
    ButtonEvent? buttonEvent,
    FontWeight? textWeight,
    TextAlign? textAlign,
    required String text,
    TextStyle? textStyle,
    bool? isDrawerShape,
    IconData? iconData,
    Color? textColor,
    bool? isCircular,
    double? iconSize,
    Color? iconColor,
  }) {
    ButtonStyle? buttonStyle;

    Color? color = ButtonUtils.getButtonColor(
      buttonEvent: buttonEvent,
    );

    buttonStyle = TextButton.styleFrom(
      shape: isDrawerShape != null && isDrawerShape
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(
                  100.sp,
                ),
                topRight: Radius.circular(
                  100.sp,
                ),
              ),
            )
          : isCircular != null && isCircular
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    100.sp,
                  ),
                )
              : null,
      backgroundColor: buttonBackgroundColor,
      alignment: buttonAlignment,
      foregroundColor: color,
      textStyle: textStyle,
    );

    String newText = text.trim().isNotEmpty ? text.trim() : "...";

    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;

    if (textAlign != null) {
      mainAxisAlignment = ButtonUtils.getButtonMainAxisAlignment(
        textAlign: textAlign,
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 1.sp,
        ),
        child: iconData != null
            ? Row(
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  Container(
                    margin: iconMargin,
                    child: Icon(
                      color: iconColor,
                      size: iconSize,
                      iconData,
                    ),
                  ),
                  Flexible(
                    child: AppText.google(
                      textAlign: textAlign,
                      weight: textWeight,
                      color: textColor,
                      text: newText,
                    ),
                  ),
                ],
              )
            : AppText.google(
                textAlign: textAlign,
                weight: textWeight,
                color: textColor,
                text: newText,
              ),
      ),
    );
  }

  static OutlinedButton outline({
    AlignmentGeometry? buttonAlignment,
    EdgeInsetsGeometry? iconMargin,
    Color? buttonBackgroundColor,
    void Function()? onPressed,
    ButtonEvent? buttonEvent,
    FontWeight? textWeight,
    TextAlign? textAlign,
    required String text,
    TextStyle? textStyle,
    IconData? iconData,
    Color? textColor,
    bool? isCircular,
    double? iconSize,
    Color? iconColor,
  }) {
    ButtonStyle? buttonStyle;

    Color? color = ButtonUtils.getButtonColor(
      buttonEvent: buttonEvent,
    );

    buttonStyle = OutlinedButton.styleFrom(
      shape: isCircular != null && isCircular
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                100.sp,
              ),
            )
          : null,
      backgroundColor: buttonBackgroundColor,
      alignment: buttonAlignment,
      foregroundColor: color,
      textStyle: textStyle,
      side: BorderSide(
        color: onPressed != null ? color ?? AppColor.transparent : AppColor.greyD2D2D2,
        width: 1.4.sp,
      ),
    );

    String newText = text.trim().isNotEmpty ? text.trim() : "...";

    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;

    if (textAlign != null) {
      mainAxisAlignment = ButtonUtils.getButtonMainAxisAlignment(
        textAlign: textAlign,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 1.sp,
        ),
        child: iconData != null
            ? Row(
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  Container(
                    margin: iconMargin,
                    child: Icon(
                      color: iconColor,
                      size: iconSize,
                      iconData,
                    ),
                  ),
                  Flexible(
                    child: AppText.google(
                      textAlign: textAlign,
                      weight: textWeight,
                      color: textColor,
                      text: newText,
                    ),
                  ),
                ],
              )
            : AppText.google(
                textAlign: textAlign,
                weight: textWeight,
                color: textColor,
                text: newText,
              ),
      ),
    );
  }

  static ElevatedButton fill({
    AlignmentGeometry? buttonAlignment,
    EdgeInsetsGeometry? iconMargin,
    void Function()? onPressed,
    ButtonEvent? buttonEvent,
    FontWeight? textWeight,
    TextAlign? textAlign,
    required String text,
    TextStyle? textStyle,
    bool? isDrawerShape,
    IconData? iconData,
    Color? textColor,
    bool? isCircular,
    double? iconSize,
    Color? iconColor,
  }) {
    ButtonStyle? elevatedButtonStyle;

    Color? backgroundColor = ButtonUtils.getButtonColor(
      buttonEvent: buttonEvent,
    );

    elevatedButtonStyle = ElevatedButton.styleFrom(
      shape: isDrawerShape != null && isDrawerShape
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(
                  100.sp,
                ),
                topRight: Radius.circular(
                  100.sp,
                ),
              ),
            )
          : isCircular != null && isCircular
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    100.sp,
                  ),
                )
              : null,
      backgroundColor: backgroundColor,
      alignment: buttonAlignment,
      textStyle: textStyle,
    );

    String newText = text.trim().isNotEmpty ? text.trim() : "...";

    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;

    if (textAlign != null) {
      mainAxisAlignment = ButtonUtils.getButtonMainAxisAlignment(
        textAlign: textAlign,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: elevatedButtonStyle,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 1.sp,
        ),
        child: iconData != null
            ? Row(
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  Container(
                    margin: iconMargin,
                    child: Icon(
                      color: iconColor,
                      size: iconSize,
                      iconData,
                    ),
                  ),
                  Flexible(
                    child: AppText.google(
                      textAlign: textAlign,
                      weight: textWeight,
                      color: textColor,
                      text: newText,
                    ),
                  ),
                ],
              )
            : AppText.google(
                textAlign: textAlign,
                weight: textWeight,
                color: textColor,
                text: newText,
              ),
      ),
    );
  }
}
