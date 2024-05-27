import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/components/splash_logo.dart';
import 'package:talimger_mobile/configs/features_config.dart';
import 'package:talimger_mobile/screens/auth/no_user.dart';
import 'package:talimger_mobile/services/auth_service.dart';
import 'package:simple_animations/simple_animations.dart';
import '../core/home.dart';
import '../providers/app_settings_provider.dart';
import '../providers/user_data_provider.dart';
import '../utils/next_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // Getting required settings data
  _getRequiredData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Signed In
      await ref.read(userDataProvider.notifier).getData();
      final userData = ref.read(userDataProvider);
      if (userData != null) {
        if (ref.read(appSettingsProvider) == null) {
          await ref.read(appSettingsProvider.notifier).getData();
        }
        if (!mounted) return;

        NextScreen.replaceAnimation(context, const Home());
      } else {
        // if user not fould
        await AuthService().userLogOut();
        if (!mounted) return;
        NextScreen.replace(context, const NoUserFound());
      }
    } else {
      // Signed Out
      await ref.read(appSettingsProvider.notifier).getData();

      NextScreen.replaceAnimation(context, const Home());
    }
  }

  @override
  void initState() {
    super.initState();
    _getRequiredData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !splashIconAnimationEnabled
          ? const Center(child: SplashLogo())
          : MirrorAnimationBuilder<double>(
              curve: Curves.easeInOut,
              tween: Tween(begin: 100.0, end: 200),
              duration: const Duration(milliseconds: 900),
              builder: (context, value, _) {
                return Center(
                  child: SizedBox(
                    height: value,
                    width: value,
                    child: const SplashLogo(),
                  ),
                );
              },
            ),
    );
  }
}
