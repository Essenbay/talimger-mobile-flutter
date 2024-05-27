import 'dart:io';

mixin IAPMixin {
  static int getExpirePeriodAsDays(String productId) {
    final String formattedString = productId.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(formattedString.trim());
  }

  String getProductTitle(String title) {
    if (Platform.isAndroid) {
      final RegExp regExp = RegExp(r'\([^()]*\)');
      String result = title.replaceFirst(regExp, '');
      return result.trim();
    } else {
      return title;
    }
  }
}
