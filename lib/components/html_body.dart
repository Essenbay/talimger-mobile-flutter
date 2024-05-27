import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/constants/custom_colors.dart';
import 'package:talimger_mobile/theme/theme_provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../services/app_service.dart';

class HtmlBody extends ConsumerWidget {
  const HtmlBody({
    super.key,
    required this.description,
    this.fontSize,
  });

  final String description;
  final double? fontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    return HtmlWidget(
      description,
      onTapUrl: (url) {
        AppService().openLinkWithCustomTab(url);
        return true;
      },
      textStyle: TextStyle(
        color: isDarkMode
            ? CustomColor.paragraphColorDark
            : CustomColor.paragraphColor,
      ),
    );
  }
}
