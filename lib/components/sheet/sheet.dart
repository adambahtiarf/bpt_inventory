import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_enums.dart';
import '../../core/constant/constants.dart';
import '../../core/utils/app_util.dart';
import '../../core/utils/string_util.dart';
import '../button/button.dart';
import '../header/header.dart';
import '../icon/icon.dart';
import '../text/text.dart';

class AppSheet {
  static Future<dynamic>? options({
    required TextEditingController controller,
    required List<String> items,
    required BuildContext context,
    required String titleText,
    required bool mounted,
  }) {
    if (Platform.isAndroid || Platform.isIOS) {
      final viewInsets = MediaQuery.of(context).viewInsets;

      return showModalBottomSheet(
        builder: (_) => PopScope(
          canPop: Constants.kCannotPop,
          child: SafeArea(
            maintainBottomViewPadding: Platform.isAndroid || Platform.isIOS,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: ((MediaQuery.of(context).size.height) / 2),
                minHeight: viewInsets.bottom,
              ),
              child: Container(
                color: AppColor.whiteF4F6F8,
                child: Column(
                  children: [
                    AppHeader.global(
                      leadingIcon: AppIcon.closeRounded(),
                      title: titleText.trim().isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText.google(
                                  overflow: TextOverflow.ellipsis,
                                  weight: FontWeight.bold,
                                  text: titleText.trim(),
                                  softWrap: true,
                                  size: 14.sp,
                                ),
                              ],
                            )
                          : null,
                      leadingFunction: Get.back,
                      centerTitle: false,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: items.length,
                          padding: EdgeInsets.symmetric(
                            vertical: 4.sp,
                          ),
                          itemBuilder: (_, i) {
                            if (items[i].trim().isNotEmpty) {
                              final isSelected = controller.text.trim().isNotEmpty && controller.text.trim() == items[i].trim();

                              final iconData = isSelected ? AppIcon.radioButtonChecked() : AppIcon.radioButtonUnchecked();

                              final iconColor = isSelected ? AppColor.blue0C5697 : AppColor.grey808080;

                              return Container(
                                margin: EdgeInsets.only(
                                  top: i != 0 ? 4.sp : 0,
                                ),
                                child: Material(
                                  color: AppColor.white,
                                  child: InkWell(
                                    onTap: () {
                                      // Update the controller text with the selected item
                                      controller.text = items[i];

                                      // Close the bottom sheet
                                      if (mounted) {
                                        Get.back();
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.sp,
                                        vertical: 10.sp,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: AppText.google(
                                              text: items[i].trim(),
                                              overflow: TextOverflow.ellipsis,
                                              weight: FontWeight.w500,
                                              softWrap: true,
                                              maxLines: 2,
                                              size: 12.sp,
                                            ),
                                          ),
                                          Icon(
                                            color: iconColor,
                                            size: 20.sp,
                                            iconData,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
      );
    }

    return null;
  }

  static Future<dynamic>? selectOne({
    List<String> options = const [],
    required BuildContext context,
    required void Function({
      required String value,
    }) onSelectItem,
    required String title,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;

      await Future.delayed(const Duration(milliseconds: 100));
      return showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              4.sp,
            ),
            topLeft: Radius.circular(
              4.sp,
            ),
          ),
        ),
        builder: (_) => PopScope(
          canPop: Constants.kCannotPop,
          child: SafeArea(
            maintainBottomViewPadding: Platform.isAndroid || Platform.isIOS,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (MediaQuery.of(context).size.height - AppUtil.statusBarHeight(context: context)),
                minHeight: viewInsets.bottom,
              ),
              child: Container(
                color: AppColor.whiteF4F6F8,
                child: Column(
                  children: [
                    AppHeader.global(
                      leadingIcon: AppIcon.closeRounded(),
                      leadingFunction: () => Get.back(),
                      title: title.trim().isNotEmpty
                          ? AppText.google(
                              weight: FontWeight.bold,
                              text: title.trim(),
                              size: 14.sp,
                            )
                          : null,
                      centerTitle: false,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.separated(
                          separatorBuilder: (_, __) => Divider(
                            color: AppColor.greyF3F3F3,
                            height: 1.sp,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.sp,
                          ),
                          itemBuilder: (_, i) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.sp,
                                vertical: 8.sp,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.sp,
                                vertical: 3.sp,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: options.length == 1
                                    ? BorderRadius.circular(
                                        4.sp,
                                      )
                                    : i == 0
                                        ? BorderRadius.only(
                                            topRight: Radius.circular(
                                              4.sp,
                                            ),
                                            topLeft: Radius.circular(
                                              4.sp,
                                            ),
                                          )
                                        : i == (options.length - 1)
                                            ? BorderRadius.only(
                                                bottomRight: Radius.circular(
                                                  4.sp,
                                                ),
                                                bottomLeft: Radius.circular(
                                                  4.sp,
                                                ),
                                              )
                                            : BorderRadius.zero,
                                color: AppColor.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 3.sp,
                                        left: 9.sp,
                                      ),
                                      child: AppText.google(
                                        overflow: TextOverflow.ellipsis,
                                        weight: FontWeight.w400,
                                        text: StringUtil.toTitleCase(options[i]),
                                        softWrap: true,
                                        maxLines: 3,
                                        size: 12.sp,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 9.sp,
                                    ),
                                    child: AppButton.text(
                                      buttonAlignment: Alignment.centerRight,
                                      buttonEvent: ButtonEvent.primary,
                                      onPressed: () => onSelectItem(
                                        value: options[i],
                                      ),
                                      textAlign: TextAlign.center,
                                      isCircular: true,
                                      text: "Pilih",
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: options.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
      );
    }

    return null;
  }

  static Future<Map<String, String>?> selectOneWithMapOptions({
    List<Map<String, Object>> options = const [],
    required BuildContext context,
    required void Function({required Map<String, Object> result}) onSelectItem,
    required String title,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;

      await Future.delayed(const Duration(milliseconds: 100));
      return await showModalBottomSheet<Map<String, String>>(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4.sp),
            topLeft: Radius.circular(4.sp),
          ),
        ),
        builder: (_) => PopScope(
          canPop: Constants.kCannotPop,
          child: SafeArea(
            maintainBottomViewPadding: Platform.isAndroid || Platform.isIOS,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (MediaQuery.of(context).size.height - AppUtil.statusBarHeight(context: context)),
                minHeight: viewInsets.bottom,
              ),
              child: Container(
                color: AppColor.whiteF4F6F8,
                child: Column(
                  children: [
                    AppHeader.global(
                      leadingIcon: AppIcon.closeRounded(),
                      leadingFunction: () => Get.back(),
                      title: title.trim().isNotEmpty
                          ? AppText.google(
                              weight: FontWeight.bold,
                              text: title.trim(),
                              size: 14.sp,
                            )
                          : null,
                      centerTitle: false,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.separated(
                          separatorBuilder: (_, __) => Divider(
                            color: AppColor.greyF3F3F3,
                            height: 1.sp,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.sp),
                          itemBuilder: (_, i) {
                            final option = options[i];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.sp,
                                vertical: 8.sp,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.sp,
                                vertical: 3.sp,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: options.length == 1
                                    ? BorderRadius.circular(4.sp)
                                    : i == 0
                                        ? BorderRadius.only(
                                            topRight: Radius.circular(4.sp),
                                            topLeft: Radius.circular(4.sp),
                                          )
                                        : i == (options.length - 1)
                                            ? BorderRadius.only(
                                                bottomRight: Radius.circular(4.sp),
                                                bottomLeft: Radius.circular(4.sp),
                                              )
                                            : BorderRadius.zero,
                                color: AppColor.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 3.sp,
                                        left: 9.sp,
                                      ),
                                      child: AppText.google(
                                        overflow: TextOverflow.ellipsis,
                                        weight: FontWeight.w400,
                                        text: StringUtil.toTitleCase(option['label'].toString()),
                                        softWrap: true,
                                        maxLines: 3,
                                        size: 12.sp,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 9.sp),
                                    child: AppButton.text(
                                      buttonAlignment: Alignment.centerRight,
                                      buttonEvent: ButtonEvent.primary,
                                      onPressed: () => onSelectItem(
                                        result: option,
                                      ),
                                      textAlign: TextAlign.center,
                                      isCircular: true,
                                      text: "Pilih",
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: options.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
      );
    }

    return null;
  }
}
