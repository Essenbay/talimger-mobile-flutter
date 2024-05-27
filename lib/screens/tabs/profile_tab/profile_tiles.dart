import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:talimger_mobile/configs/app_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/screens/edit_profile.dart';
import 'package:talimger_mobile/screens/tabs/profile_tab/about_us.dart';
import 'package:talimger_mobile/screens/tabs/profile_tab/settings.dart';
import 'package:line_icons/line_icons.dart';
import 'package:talimger_mobile/mixins/user_mixin.dart';
import '../../../providers/app_settings_provider.dart';
import '../../../providers/user_data_provider.dart';
import '../../../services/app_service.dart';
import '../../../utils/logout_dialog.dart';
import '../../../utils/next_screen.dart';

class ProfileTiles extends ConsumerWidget with UserMixin {
  const ProfileTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setttings = ref.watch(appSettingsProvider);
    final user = ref.watch(userDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        if (user != null)
          ListTile(
            title: const Text('change_profile').tr(),
            leading: const Icon(
              FeatherIcons.edit3,
              size: 20,
            ),
            trailing: const Icon(FeatherIcons.chevronRight),
            onTap: () => NextScreen.openBottomSheet(
                context, EditProfile(user: user),
                maxHeight: 0.80),
          ),
        if (user != null) const Divider(),
        ListTile(
          title: const Text('settings').tr(),
          leading: const Icon(CupertinoIcons.settings),
          trailing: const Icon(FeatherIcons.chevronRight),
          onTap: () {
            NextScreen.iOS(context, const SettingsScreen());
          },
        ),
        const Divider(),
        ListTile(
            title: const Text('about_us').tr(),
            leading: const Icon(LineIcons.infoCircle),
            trailing: const Icon(FeatherIcons.chevronRight),
            onTap: () {
              NextScreen.iOS(context, const AboutUsScreen());
            }),
        const Divider(),
        ListTile(
          title: const Text('privacy-policy').tr(),
          leading: const Icon(LineIcons.lock),
          trailing: const Icon(FeatherIcons.chevronRight),
          onTap: () =>
              AppService().openLinkWithCustomTab(setttings?.privacyUrl ?? ''),
        ),
        Visibility(
          visible:
              (Platform.isAndroid && AppConfig.androidPackageName.isNotEmpty) ||
                  (Platform.isIOS && AppConfig.iosAppID.isNotEmpty),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              ListTile(
                title: const Text('rate-app').tr(),
                leading: const Icon(LineIcons.star),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () => AppService().launchAppReview(context),
              ),
            ],
          ),
        ),
        Visibility(
          visible: user != null,
          child: Column(
            children: [
              const Divider(),
              ListTile(
                title: const Text('logout').tr(),
                leading: const Icon(FeatherIcons.logOut),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () {
                  openLogoutDialog(
                      context, () => handleLogout(context, ref: ref));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
