import 'package:intl/intl.dart';

class UtilDate {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat("dd-MM-yyyy HH:mm:ss").format(dateTime.toLocal());
  }

  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "-";
    }
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

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} weeks ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else {
      return "${(difference.inDays / 365).floor()} years ago";
    }
  }
}
