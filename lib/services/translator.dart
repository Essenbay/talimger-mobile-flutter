import 'package:translator/translator.dart';

class Translator {
  Translator();

  static Future<String> translate(String? text, String languageCode) async {
    try {
      if (languageCode == 'en') {
        return text ?? '';
      }
      
      if (text == null) {
        return '';
      }

      final translator = GoogleTranslator();
      final result =
          await translator.translate(text, from: 'en', to: languageCode);
      return result.text;
    } catch (e) {
      return text ?? '';
    }
  }
}
