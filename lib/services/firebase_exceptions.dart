import 'package:easy_localization/easy_localization.dart';

String getTranlsatedFirebaseError(String code) => switch (code) {
      'email-already-exists' => 'email_already_exists',
      'invalid-credential' => 'invalid_credentials',
      'invalid-email' => 'invalid_email',
      'invalid-password' => 'invalid_password',
      'invalid-phone-number' => 'invalid_phone_number',
      'user-not-found' => 'user_now_found',
      _ => 'unknown_error',
    }
        .tr();
