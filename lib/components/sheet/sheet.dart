import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/constants.dart';
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
    required int index,
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
}
