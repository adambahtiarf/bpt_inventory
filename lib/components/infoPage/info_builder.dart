import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_enums.dart';
import '../blank/blank.dart';
import '../button/button.dart';
import '../text/text.dart';

class InfoBuilder extends StatelessWidget {
  final String title, buttonText, description;

  final void Function()? onPressed;

  final Color? textColor;

  const InfoBuilder({
    required this.description,
    required this.buttonText,
    required this.onPressed,
    required this.title,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (description.trim().isNotEmpty && title.trim().isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.google(
            textAlign: TextAlign.center,
            weight: FontWeight.bold,
            text: title.trim(),
            color: textColor,
            size: 14.sp,
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: onPressed != null && buttonText.trim().isNotEmpty ? 23.sp : 0,
              top: 3.sp,
            ),
            child: AppText.google(
              textAlign: TextAlign.center,
              text: description.trim(),
              color: textColor,
              maxLines: 2,
              size: 12.sp,
            ),
          ),
          if (onPressed != null && buttonText.trim().isNotEmpty)
            AppButton.fill(
              buttonEvent: ButtonEvent.primary,
              text: buttonText.trim(),
              onPressed: onPressed,
            ),
        ],
      );
    }

    return const Blank();
  }
}
