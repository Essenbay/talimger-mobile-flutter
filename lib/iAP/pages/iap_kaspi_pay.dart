import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/configs/app_assets.dart';
import 'package:talimger_mobile/configs/app_config.dart';
import 'package:talimger_mobile/providers/app_settings_provider.dart';
import 'package:talimger_mobile/services/app_service.dart';
import 'package:talimger_mobile/utils/snackbars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:line_icons/line_icons.dart';

class IAPKaspiPay extends ConsumerWidget {
  const IAPKaspiPay(
      {super.key, required this.kaspiLink, required this.coursePrice});
  final String kaspiLink;
  final String coursePrice;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricedouble = double.tryParse(coursePrice);
    final setttings = ref.watch(appSettingsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(kaspiLogo, height: 100, width: 100),
          ),
          const SizedBox(height: 20),
          Text(
            'kaspi_pay_title',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(height: 10),
          Text(
            'pay_by_link',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.blueGrey, fontSize: 18),
          ).tr(),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'price'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 18),
              ),
              const Spacer(),
              Text(
                pricedouble == null ? coursePrice : '$pricedouble ₸',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppConfig.appThemeColor),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(child: Text(kaspiLink)),
                CupertinoButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: kaspiLink));
                    openSnackbar(context, 'copied'.tr());
                  },
                  minSize: 10,
                  padding: const EdgeInsets.all(5),
                  child: const Icon(Icons.copy),
                ),
                CupertinoButton(
                  minSize: 10,
                  padding: const EdgeInsets.all(10),
                  onPressed: () {
                    AppService().openLink(kaspiLink);
                  },
                  child: const Icon(
                    Icons.navigate_next_sharp,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'save_receipt',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.blueGrey[400], fontSize: 16),
          ).tr(),
          const SizedBox(height: 10),
          const Spacer(),
          ListTile(
            title: const Text('error_support').tr(),
            leading: const Icon(LineIcons.whatSApp),
            trailing: const Icon(FeatherIcons.chevronRight),
            onTap: () => AppService().openLink(setttings!.whatsapp!),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
