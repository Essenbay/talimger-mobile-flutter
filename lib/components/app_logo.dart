import 'package:flutter/material.dart';
import 'package:talimger_mobile/configs/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height ?? 60,
      // width: width ?? 60,
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Image.asset(
        logo,
        height: height ?? 50,
        width: width ?? 50,
      ),
    );
  }
}
