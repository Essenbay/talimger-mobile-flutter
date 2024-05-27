import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/components/languages.dart';
import 'package:talimger_mobile/configs/features_config.dart';
import 'package:talimger_mobile/screens/auth/delete_account.dart';
import 'package:talimger_mobile/services/notification_service.dart';
import 'package:talimger_mobile/theme/theme_provider.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import 'package:line_icons/line_icons.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool notificationEnbaled = ref.watch(nProvider);

    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('settings').tr(),
            pinned: true,
            titleTextStyle: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20).copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(notificationEnbaled
                        ? LineIcons.bell
                        : LineIcons.bellSlash),
                    title: const Text('notifications').tr(),
                    trailing: Switch.adaptive(
                      value: notificationEnbaled,
                      onChanged: (value) => NotificationService()
                          .handleSubscription(context, value, ref),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('dark-mode').tr(),
                    trailing: Switch.adaptive(
                      value: ref.watch(themeProvider).isDarkMode,
                      onChanged: (value) =>
                          ref.read(themeProvider.notifier).changeTheme(value),
                    ),
                  ),
                  Visibility(
                    visible: isMultilanguageEnbled,
                    child: Column(
                      children: [
                        const Divider(),
                        ListTile(
                          title: const Text('language').tr(),
                          leading: const Icon(LineIcons.language),
                          trailing: const Icon(FeatherIcons.chevronRight),
                          onTap: () => NextScreen.openBottomSheet(
                              context, const Languages()),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(LineIcons.removeUser),
                    title: const Text('delete-account').tr(),
                    trailing: const Icon(FeatherIcons.chevronRight),
                    onTap: () => NextScreen.openBottomSheet(
                        context, const DeleteDialog(),
                        maxHeight: 0.80),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
