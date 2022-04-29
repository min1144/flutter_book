import 'package:intl/intl.dart';

extension ConvertToString on String {
  String removeAllHtmlTags() {
    return replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  String omitString() {
    var convertString = removeAllHtmlTags();
    if (convertString.trim().length > 12) {
      return convertString.trim().substring(0, 12) + "...";
    }
    return convertString.trim();
  }

  String changeLocalTime() {
    try {
      DateTime dt = DateTime.parse(this);
      return DateFormat('yyyy/MM/dd').format(dt);
    } catch (e) {}
    return '';
  }
}
