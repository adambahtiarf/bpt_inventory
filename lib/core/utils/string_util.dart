class StringUtil {
  static String toTitleCase(String str) {
    return str.toLowerCase().split(' ').map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
    }).join(' ');
  }
}
