import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/utils/app_util.dart';
import '../button/button.dart';

class AppInput {
  static TextFormField global({
    bool isRoundedInputBorderDecoration = false,
    double roundedInputBorderDecorationValue = 0,
    void Function(String)? onFieldSubmitted,
    required TextEditingController txtCtrl,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    AutovalidateMode? validateMode,
    void Function()? suffixFunc,
    void Function()? prefixFunc,
    TextInputType? keyboardType,
    void Function()? onTapFunc,
    TextInputAction? action,
    double? suffixIconSize,
    double? prefixIconSize,
    bool autofocus = false,
    bool readOnly = false,
    Widget? suffixWidget,
    Widget? prefixWidget,
    IconData? suffixIcon,
    IconData? prefixIcon,
    bool obscure = false,
    Color? suffixColor,
    Color? prefixColor,
    int? maxLines = 1,
    String? hintText,
    TextStyle? hintStyle,
    int? minLines,
    Color? fillColor,
    bool isNotBordered = false,
    bool? enabled = true,
    String? initialValue,
    EdgeInsets? contentPadding,
    bool? isDense,
    Color? textColor,
  }) {
    Widget? suffix;
    Widget? prefix;

    double cWidth = 2;

    if (AppUtil.isTablet) {
      cWidth = 1.7.sp;
    }

    if (suffixWidget != null) {
      suffix = suffixWidget;
    } else {
      if (suffixIcon != null) {
        suffix = AppButton.icon(
          iconButtonSize: suffixIconSize,
          suffixWidget: suffixWidget,
          iconColor: suffixColor,
          onPressed: suffixFunc,
          iconData: suffixIcon,
          isSuffix: true,
        );
      }
    }
    if (prefixWidget != null) {
      prefix = prefixWidget;
    } else {
      if (prefixIcon != null) {
        prefix = AppButton.icon(
          iconButtonSize: prefixIconSize,
          suffixWidget: prefixWidget,
          iconColor: prefixColor,
          onPressed: prefixFunc,
          iconData: prefixIcon,
          isSuffix: false,
        );
      }
    }
    return TextFormField(
      onTap: readOnly ? onTapFunc : null,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: validateMode,
      decoration: InputDecoration(
        isDense: isDense,
        contentPadding: contentPadding,
        fillColor: fillColor,
        focusedErrorBorder: isRoundedInputBorderDecoration
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(roundedInputBorderDecorationValue.sp),
                borderSide: BorderSide(
                  color: enabled == false ? AppColor.greyAAAAAA : AppColor.grey6B6B6B,
                  style: BorderStyle.solid,
                  width: 1.sp,
                ),
              )
            : null,
        disabledBorder: isRoundedInputBorderDecoration
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(roundedInputBorderDecorationValue.sp),
                borderSide: BorderSide(
                  color: AppColor.grey6B6B6B,
                  style: BorderStyle.solid,
                  width: 1.sp,
                ),
              )
            : null,
        enabledBorder: isRoundedInputBorderDecoration
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(roundedInputBorderDecorationValue.sp),
                borderSide: BorderSide(
                  color: AppColor.grey6B6B6B,
                  style: BorderStyle.solid,
                  width: 1.sp,
                ),
              )
            : null,
        focusedBorder: isRoundedInputBorderDecoration
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(roundedInputBorderDecorationValue.sp),
                borderSide: BorderSide(
                  color: AppColor.grey6B6B6B,
                  style: BorderStyle.solid,
                  width: 1.sp,
                ),
              )
            : null,
        errorBorder: isRoundedInputBorderDecoration
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(roundedInputBorderDecorationValue.sp),
                borderSide: BorderSide(
                  color: AppColor.greyD2D2D2,
                  style: BorderStyle.solid,
                  width: 1.sp,
                ),
              )
            : null,
        border: isRoundedInputBorderDecoration || isNotBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(roundedInputBorderDecorationValue.sp),
                borderSide: BorderSide(
                  color: AppColor.grey6B6B6B,
                  style: BorderStyle.solid,
                  width: 1.sp,
                ),
              )
            : null,
        suffixIcon: suffix,
        prefixIcon: prefix,
        hintText: hintText,
        hintStyle: hintStyle,
      ),
      inputFormatters: formatters,
      keyboardType: keyboardType,
      textInputAction: action,
      onChanged: onChanged,
      autofocus: autofocus,
      validator: validator,
      obscureText: obscure,
      controller: enabled == true ? txtCtrl : null,
      cursorWidth: cWidth,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      style: TextStyle(color: textColor ?? AppColor.black),
    );
  }
}
