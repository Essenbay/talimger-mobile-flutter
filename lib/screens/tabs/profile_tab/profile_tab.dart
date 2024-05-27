import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/screens/notifications/notifications.dart';
import 'package:talimger_mobile/screens/tabs/profile_tab/profile_tiles.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import 'package:line_icons/line_icons.dart';
import '../../../providers/user_data_provider.dart';
import 'guest_user.dart';
import 'user_info.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('profile').tr(),
          pinned: true,
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
          actions: [
            IconButton(
              onPressed: () {
                NextScreen.iOS(context, const Notifications());
              },
              icon: const Icon(LineIcons.bell),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                user == null
                    ? const GuestUser()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: UserInfo(user: user, ref: ref),
                      ),
                const ProfileTiles(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
