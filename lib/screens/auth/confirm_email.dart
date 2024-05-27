import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/providers/app_settings_provider.dart';
import 'package:talimger_mobile/services/app_service.dart';
import 'package:talimger_mobile/services/auth_service.dart';
import 'package:talimger_mobile/utils/loading_widget.dart';
import 'package:talimger_mobile/utils/snackbars.dart';
import 'package:line_icons/line_icons.dart';

final _isLoadingEnrollmentProvider = StateProvider.autoDispose((ref) => false);

class ConfirmEmailScreen extends ConsumerStatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends ConsumerState<ConfirmEmailScreen> {
  Timer? _timer;
  bool _isButtonInCooldown = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _enableSendButtonAfterCooldown() {
    _timer = Timer(const Duration(seconds: 60), () {
      setState(() {
        _isButtonInCooldown = false;
      });
    });
  }

  void _handleSendVerificationEmail() {
    AuthService().sendEmailVerification();
    setState(() {
      _isButtonInCooldown = true;
    });
    _enableSendButtonAfterCooldown();
  }

  Future _handleConfirmationCheck() async {
    final isConfirmed = await AuthService().isConfirmed(context);
    if (isConfirmed) {
      final navigator = Navigator.of(context);
      navigator.pop();
    } else {
      openSnackbarFailure(context, 'confirm_error'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final setttings = ref.watch(appSettingsProvider);
    final bool isLoading = ref.watch(_isLoadingEnrollmentProvider);

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'confirm_email',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 28),
            ).tr(),
            const SizedBox(height: 5),
            Text(
              'confirm_email_desc',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ).tr(),
            const Spacer(),
            Visibility(
              visible: setttings?.whatsapp?.isNotEmpty == true,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('contact-us').tr(),
                    leading: const Icon(LineIcons.whatSApp),
                    trailing: const Icon(FeatherIcons.chevronRight),
                    onTap: () => AppService().openLink(setttings!.whatsapp!),
                  ),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
                minimumSize: const Size.fromHeight(60),
              ),
              child: isLoading
                  ? const LoadingIndicatorWidget(color: Colors.white)
                  : Text(
                      'i_have_confirmed'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                    ).tr(),
              onPressed: () async {
                ref.read(_isLoadingEnrollmentProvider.notifier).state = true;
                await _handleConfirmationCheck();
                ref.read(_isLoadingEnrollmentProvider.notifier).state = false;
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed:
                  _isButtonInCooldown ? null : _handleSendVerificationEmail,
              child: Text(
                'send_again'.tr(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
