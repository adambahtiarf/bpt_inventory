class StringUtil {
  static String toTitleCase(String str) {
    return str.toLowerCase().split(' ').map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
    }).join(' ');
  }

  static String? extractAssetCode(String url) {
    RegExp regex = RegExp(r'asset/([A-Z]+-\d+)');
    Match? match = regex.firstMatch(url);

    return match?.group(1);
  }
}
