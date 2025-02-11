import 'package:intl/intl.dart';

class UtilDate {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat("dd-MM-yyyy HH:mm:ss").format(dateTime.toLocal());
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime.toLocal());
  }

  static String formatDateTimeWithOffset(DateTime dateTime) {
    final offset = dateTime.timeZoneOffset;
    final hoursOffset = offset.inHours.abs().toString().padLeft(2, '0');
    final minutesOffset = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';

    final formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime.toLocal());
    return "$formattedDate$sign$hoursOffset:$minutesOffset";
  }
}
