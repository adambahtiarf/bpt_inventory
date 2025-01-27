import 'package:flutter/material.dart';

import '../../data/type/message_params.dart';
import '../constant/app_colors.dart';
import '../constant/app_enums.dart';

class MessageUtil {
  static Color getMessageColor({
    required MessageParams params,
  }) {
    Color color = AppColor.black303030;

    if (params.messageEvent != null) {
      switch (params.messageEvent) {
        case MessageEvent.success:
          color = AppColor.green52C41A;

          break;

        case MessageEvent.error:
          color = AppColor.redCF1322;

          break;

        case MessageEvent.info:
          color = AppColor.blue17A2B8;

          break;

        default:
      }
    }

    return color;
  }
}
