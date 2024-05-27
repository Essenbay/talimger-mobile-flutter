import 'package:talimger_mobile/utils/snackbars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/dialogs.dart';

void openEnrollSuccessDialog(
    BuildContext context, String message, String requestId) {
  return Dialogs.bottomMaterialDialog(
      context: context,
      title: message.tr(),
      msg: '${'request_id'.tr()}: $requestId',
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      color: Theme.of(context).canvasColor,
      isDismissible: true,
      actions: [
        TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: requestId));
            openSnackbar(context, 'copied'.tr());
          },
          child: Text(
            'copy'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'ok'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ]);
}
