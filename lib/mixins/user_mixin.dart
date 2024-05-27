import 'package:talimger_mobile/models/app_settings_model.dart';
import 'package:talimger_mobile/screens/auth/confirm_email.dart';
import 'package:talimger_mobile/screens/notifications/enroll_success_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/models/course.dart';
import 'package:talimger_mobile/models/user_model.dart';
import 'package:talimger_mobile/screens/curricullam_screen.dart';
import 'package:talimger_mobile/screens/home/home_bottom_bar.dart';
import 'package:talimger_mobile/screens/home/home_view.dart';
import 'package:talimger_mobile/screens/auth/login.dart';
import 'package:talimger_mobile/services/auth_service.dart';
import 'package:talimger_mobile/services/firebase_service.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import 'package:talimger_mobile/utils/snackbars.dart';
import '../iAP/iap_screen.dart';
import '../providers/user_data_provider.dart';

mixin UserMixin {
  void handleLogout(context, {required WidgetRef ref}) async {
    await AuthService()
        .userLogOut()
        .onError((error, stackTrace) => debugPrint('error: $error'));

    ref.invalidate(userDataProvider);
    ref.invalidate(homeTabControllerProvider);
    ref.invalidate(navBarIndexProvider);
    NextScreen.openBottomSheet(context, const LoginScreen());
  }

  bool hasEnrolled(UserModel? user, Course course) {
    if (user != null &&
        user.enrolledCourses != null &&
        user.enrolledCourses!.contains(course.id)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isExpired(UserModel user) {
    return false;
  }

  static bool isUserPremium(UserModel? user) {
    return user != null && user.subscription != null && isExpired(user) == false
        ? true
        : false;
  }

  int remainingDays(UserModel user) {
    final DateTime expireDate = user.subscription!.expireAt;
    final DateTime now = DateTime.now().toUtc();
    final difference = expireDate.difference(now).inDays;
    return difference;
  }

  Future handleEnrollment(
    BuildContext context, {
    required UserModel? user,
    required Course course,
    required WidgetRef ref,
  }) async {
    if (isTesting) {
      NextScreen.popup(context, CurriculamScreen(course: course));
      return;
    }
    if (user != null) {
      if (course.price == null) {
        if (hasEnrolled(user, course)) {
          NextScreen.popup(context, CurriculamScreen(course: course));
        } else {
          await _comfirmEnrollment(context, user, course, ref);
          await FirebaseService().updateStudentCountsOnCourse(true, course.id);
        }
        return;
      } else {
        //  Premium Course
        if (hasEnrolled(user, course)) {
          NextScreen.popup(context, CurriculamScreen(course: course));
        } else {
          final isConfirmed = await AuthService().isConfirmed(context);
          if (isConfirmed) {
            final result = await NextScreen.openBottomSheet(
                context,
                IAPScreen(
                  userId: user.id,
                  course: course,
                ),
                isDismissable: false);
            if (result is String) {
              openEnrollSuccessDialog(
                  context, 'form_send_success'.tr(), result);
            }
          } else {
            NextScreen.openBottomSheet(context, const ConfirmEmailScreen());
          }
        }
        return;
      }
    } else {
      NextScreen.openBottomSheet(context, const LoginScreen(popUpScreen: true));
    }
  }

  Future _comfirmEnrollment(BuildContext context, UserModel user, Course course,
      WidgetRef ref) async {
    await FirebaseService().updateEnrollment(user, course);
    await ref.read(userDataProvider.notifier).getData();
    if (!context.mounted) return;
    openSnackbar(context, '${'success'.tr()}!');
  }

  Future handleOpenCourse(
    BuildContext context, {
    required UserModel user,
    required Course course,
  }) async {
    if (course.price == null) {
      NextScreen.popup(context, CurriculamScreen(course: course));
    } else {
      if (!isExpired(user)) {
        NextScreen.popup(context, CurriculamScreen(course: course));
      } else {
        final result = await NextScreen.openBottomSheet(
            context,
            IAPScreen(
              userId: user.id,
              course: course,
            ));
        if (result is String) {
          openEnrollSuccessDialog(context, 'form_send_success'.tr(), result);
        }
      }
    }
  }
}
