import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/providers/app_settings_provider.dart';
import 'package:talimger_mobile/services/app_service.dart';
import 'package:talimger_mobile/utils/custom_cached_image.dart';
import 'package:line_icons/line_icons.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setttings = ref.watch(appSettingsProvider);

    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('about_us').tr(),
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
                  if (setttings?.aboutImage != null)
                    CustomCacheImage(
                      imageUrl: setttings?.aboutImage,
                      radius: 30,
                      height: 160,
                    ),
                  const SizedBox(height: 20),
                  if (setttings?.aboutDescription != null)
                    Text(
                      setttings!.aboutDescription!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  if (setttings?.supportEmail != null &&
                      setttings?.supportEmail?.isNotEmpty == true)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        const Divider(),
                        ListTile(
                          title: const Text('contact-us').tr(),
                          leading: const Icon(LineIcons.envelope),
                          trailing: const Icon(FeatherIcons.chevronRight),
                          onTap: () => AppService()
                              .openEmailSupport(setttings?.supportEmail ?? ''),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
                    child: const Text(
                      'social',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ).tr(),
                  ),
                  Visibility(
                    visible: setttings?.whatsapp?.isNotEmpty == true,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('WhatsApp'),
                          leading: const Icon(LineIcons.whatSApp),
                          trailing: const Icon(FeatherIcons.chevronRight),
                          onTap: () =>
                              AppService().openLink(setttings!.whatsapp!),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: setttings?.telegram?.isNotEmpty == true,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Telegram'),
                          leading: const Icon(LineIcons.telegram),
                          trailing: const Icon(FeatherIcons.chevronRight),
                          onTap: () =>
                              AppService().openLink(setttings!.telegram!),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: setttings?.social?.fb?.isNotEmpty == true,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('facebook').tr(),
                          leading: const Icon(LineIcons.facebook),
                          trailing: const Icon(FeatherIcons.chevronRight),
                          onTap: () =>
                              AppService().openLink(setttings!.social!.fb!),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: setttings?.social?.youtube?.isNotEmpty == true,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('youtube').tr(),
                          leading: const Icon(LineIcons.youtube),
                          trailing: const Icon(FeatherIcons.chevronRight),
                          onTap: () => AppService()
                              .openLink(setttings!.social!.youtube!),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: setttings?.social?.twitter?.isNotEmpty == true,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('twitter').tr(),
                          leading: const Icon(FeatherIcons.twitter),
                          trailing: const Icon(FeatherIcons.chevronRight),
                          onTap: () => AppService()
                              .openLink(setttings!.social!.twitter!),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: setttings?.social?.instagram?.isNotEmpty == true,
                    child: ListTile(
                      title: const Text('instagram').tr(),
                      leading: const Icon(FeatherIcons.instagram),
                      trailing: const Icon(FeatherIcons.chevronRight),
                      onTap: () =>
                          AppService().openLink(setttings!.social!.instagram!),
                    ),
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
