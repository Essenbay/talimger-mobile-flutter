import 'dart:io';

import 'package:talimger_mobile/configs/app_config.dart';
import 'package:talimger_mobile/iAP/file_selector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IAPSendForm extends StatelessWidget {
  const IAPSendForm({super.key, this.file, required this.onChange});
  final File? file;
  final ValueChanged<File?> onChange;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor,
            child: const ClipOval(
              child: ColoredBox(
                color: AppConfig.appThemeColor,
                child: Icon(
                  Icons.attach_file,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'attach_receipt',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: FileSelector(
              selectedFile: file,
              onChange: onChange,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
