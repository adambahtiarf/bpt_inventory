import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import '../constant/app_enums.dart';

class ButtonUtils {
  static Color? getButtonColor({
    required ButtonEvent? buttonEvent,
  }) {
    Color? color = AppColor.black303030;

    if (buttonEvent != null) {
      switch (buttonEvent) {
        case ButtonEvent.secondary:
          color = AppColor.orangeEC6B0C;

          break;

        case ButtonEvent.tertiary:
          color = AppColor.redCF1322;

          break;

        case ButtonEvent.primary:
          color = AppColor.blue0A1A48;

          break;

        case ButtonEvent.cancel:
          color = AppColor.blue8EA6EB;

          break;

        case ButtonEvent.alert:
          color = AppColor.redCF1322;

          break;

        default:
      }
    }

    return color;
  }

  static MainAxisAlignment getButtonMainAxisAlignment({
    required TextAlign textAlign,
  }) {
    MainAxisAlignment result = MainAxisAlignment.start;

    switch (textAlign) {
      case TextAlign.center:
        result = MainAxisAlignment.center;

      case TextAlign.start:
        result = MainAxisAlignment.start;

      case TextAlign.end:
        result = MainAxisAlignment.end;

      default:
    }

    return result;
  }

  static String getCMTicketStatusText({required String status}) {
    switch (status) {
      case "ASSIGNMENT":
        return "Accept";
      case "ACCEPT":
        return "Arrival";
      case "ARRIVAL":
        return "Handling";
      case "HANDLING":
        return "Start";
      case "ON REVIEW":
        return "View";
      case "REJECT":
        return "View";
      case "DONE":
        return "View Detail";

      default:
        return "-";
    }
  }

  static String getCMAssetStatusText({required String status}) {
    switch (status) {
      case "":
        return "Start Work";
      case "OPEN":
        return "Start Work";
      case "ON PROGRESS":
        return "Work In Progress";
      case "SUBMITED":
        return "Submited";
      case "REJECTED":
        return "Start Work";
      case "APPROVED":
        return "View Detail";

      default:
        return "-";
    }
  }
}
