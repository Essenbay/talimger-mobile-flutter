import 'package:flutter/material.dart';

class LanguageConfig {
  //Initial Language
  static const Locale startLocale = Locale('ru', 'RU');

  //Language if any error happens
  static const Locale fallbackLocale = Locale('en', 'US');

  // Languages
  static const Map<String, List<String>> languages = {
    //language_name : [language_code, country_code(Capital format)]
    "English": ['en', 'US'],
    "Русский": ['ru', 'RU'],
    "Қазақ": ['kk', 'KK'],
  };

  // Don't edit this
  static List<Locale> supportedLocales =
      languages.values.map((e) => Locale(e.first, e.last)).toList();
}
