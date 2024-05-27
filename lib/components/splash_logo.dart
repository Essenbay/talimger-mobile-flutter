import 'package:flutter/material.dart';
import 'package:talimger_mobile/configs/app_assets.dart';
import 'package:talimger_mobile/configs/app_config.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ColoredBox(
        color: AppConfig.appThemeColor,
        child: Image.asset(
          splash,
          height: 130,
          width: 130,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
