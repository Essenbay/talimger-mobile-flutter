import 'dart:io';

import 'package:talimger_mobile/configs/app_config.dart';
import 'package:talimger_mobile/utils/snackbars.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';

class FileSelector extends StatelessWidget {
  final File? selectedFile;
  final ValueChanged<File?> onChange;

  const FileSelector({super.key, this.selectedFile, required this.onChange});

  Future _pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        onChange(file);
      } else {
        // User canceled the picker
      }
    } catch (e) {
      openSnackbarFailure(context, 'attach_failure'.tr());
    }
  }

  Future<bool> _checkPermission(BuildContext context) async {
    final isStorageRequest = Platform.isIOS ||
        (await DeviceInfoPlugin().androidInfo).version.sdkInt < 29;

    if (!isStorageRequest) {
      return true;
    }

    const permission = Permission.storage;

    final status = await permission.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      final result = await permission.request();
      if (result.isDenied) {
        openSnackbarFailure(context, 'permission_denied'.tr());
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: selectedFile == null
              ? () async {
                  final result = await _checkPermission(context);
                  if (result) {
                    _pickFile(context);
                  }
                }
              : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
              color: AppConfig.appThemeColor,
              width: 1,
            )),
            child: Stack(
              children: <Widget>[
                if (selectedFile != null)
                  selectedFile!.path.toLowerCase().endsWith('.png') ||
                          selectedFile!.path.toLowerCase().endsWith('.jpg')
                      ? Padding(
                          padding: const EdgeInsets.all(1),
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.file(
                              selectedFile!,
                            ),
                          ),
                        )
                      : IgnorePointer(
                          child: PDFView(
                            filePath: selectedFile!.path,
                            enableSwipe: false,
                            pageSnap: false,
                          ),
                        ),
                if (selectedFile == null)
                  Center(
                    child: Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.grey[800],
                    ),
                  ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            splashRadius: 18,
            splashColor: Colors.red[200],
            color: Colors.red,
            onPressed: () {
              onChange(null);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        )
      ],
    );
  }
}
