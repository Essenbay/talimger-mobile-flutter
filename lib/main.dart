import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/firebase_options.dart';
import 'package:talimger_mobile/services/app_service.dart';
import 'package:talimger_mobile/services/hive_service.dart';
import 'core/app.dart';
import 'configs/language_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    log('Error while initializing Firebase: $e');
  }
  await EasyLocalization.ensureInitialized();
  HiveService.initHive();
  AppService.svgPrecacheImage();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: LanguageConfig.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: LanguageConfig.fallbackLocale,
        startLocale: LanguageConfig.startLocale,
        child: const MyApp(),
      ),
    ),
  );
}
