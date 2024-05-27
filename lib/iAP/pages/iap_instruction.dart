import 'package:talimger_mobile/configs/app_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IAPInstruction extends ConsumerWidget {
  const IAPInstruction({
    super.key,
    required this.isAvailable,
  });
  final bool isAvailable;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isAvailable) {
      return Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor,
            child: Image.asset(premiumImage, height: 50, width: 50),
          ),
          const SizedBox(height: 20),
          Text(
            'iap-title',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ).tr(),
          const SizedBox(height: 10),
          Text(
            'iap-subtitle',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.blueGrey, fontSize: 18),
          ).tr(),
          const SizedBox(height: 20),
        ],
      );
    } else {
      return Center(
        child: Text('iap_not_avalable'.tr()),
      );
    }
  }
}
