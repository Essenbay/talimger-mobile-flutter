import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_settings_provider.dart';
import '../services/app_service.dart';

class PrivacyInfo extends ConsumerWidget {
  const PrivacyInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final String privacyUrl = settings?.privacyUrl ?? 'https://google.com';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Text(
            'policy_label_1'.tr(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              InkWell(
                  onTap: () => AppService().openLinkWithCustomTab(privacyUrl),
                  child: Text(
                    'terms-of-services'.tr(),
                    style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue),
                  )),
              const SizedBox(
                width: 5,
              ),
              Text('and'.tr()),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                  onTap: () => AppService().openLinkWithCustomTab(privacyUrl),
                  child: Text(
                    'privacy-policy'.tr(),
                    style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
