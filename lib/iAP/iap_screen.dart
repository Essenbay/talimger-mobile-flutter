import 'dart:io';
import 'package:talimger_mobile/iAP/pages/iap_kaspi_pay.dart';
import 'package:talimger_mobile/iAP/pages/iap_send_form.dart';
import 'package:talimger_mobile/models/course.dart';
import 'package:talimger_mobile/providers/app_settings_provider.dart';
import 'package:talimger_mobile/services/firebase_service.dart';
import 'package:talimger_mobile/utils/snackbars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/iAP/iap_mixin.dart';
import 'package:talimger_mobile/utils/loading_widget.dart';

class IAPScreen extends ConsumerStatefulWidget {
  const IAPScreen({super.key, required this.course, required this.userId});
  final Course course;
  final String userId;

  @override
  ConsumerState<IAPScreen> createState() => _IAPScreen2State();
}

class _IAPScreen2State extends ConsumerState<IAPScreen> with IAPMixin {
  String? kaspiLink;

  @override
  void initState() {
    kaspiLink = ref.read(appSettingsProvider)?.kaspiPaymentUrl;

    super.initState();
  }

  late final pageController = PageController();
  int page = 0;

  File? receipt;
  bool sendLoading = false;

  void _handleSend() async {
    setState(() {
      sendLoading = true;
    });

    //Check if exists
    final doesExist = await FirebaseService()
        .isEnrollRequestExists(widget.userId, widget.course.id);
    if (doesExist == true) {
      openSnackbarFailure(context, 'enroll_request_exists'.tr());
      setState(() {
        sendLoading = false;
      });
      return;
    }

    //Create image url
    final receiptUrl = await _getReceiptFile();
    if (receiptUrl == null) {
      openSnackbarFailure(context, 'photo_save_error'.tr());
      setState(() {
        sendLoading = false;
      });
      return;
    }

    //Send request
    final result = await FirebaseService().createEnrollmentRequest(
      widget.userId,
      widget.course.id,
      receiptUrl,
      widget.course.author.id,
    );
    if (result != null) {
      setState(() {
        sendLoading = false;
      });
      Navigator.of(context).pop(result);
      return;
    } else {
      openSnackbarFailure(context, 'form_send_error'.tr());
      setState(() {
        sendLoading = false;
      });
      return;
    }
  }

  Future<String?> _getReceiptFile() async {
    if (receipt != null) {
      final String? imageUrl =
          await FirebaseService().uploadReceiptToHosting(receipt!);
      return imageUrl;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) => setState(() {
                page = value;
              }),
              children: [
                // IAPInstruction(
                //   isAvailable:
                //       kaspiLink != null && (kaspiLink?.isNotEmpty ?? false),
                // ),
                IAPKaspiPay(
                  kaspiLink: kaspiLink ?? '',
                  coursePrice: widget.course.price ?? '',
                ),
                IAPSendForm(
                  file: receipt,
                  onChange: (newfile) => setState(
                    () {
                      receipt = newfile;
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: page == 0
                        ? null
                        : () {
                            pageController.previousPage(
                                duration: duration, curve: curve);
                          },
                    child: Text(
                      'back'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                    ).tr(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                        minimumSize: const Size.fromHeight(50)),
                    child: sendLoading
                        ? const LoadingIndicatorWidget(color: Colors.white)
                        : Text(
                            page == pageLen - 1 ? 'send'.tr() : 'next'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          ).tr(),
                    onPressed: () {
                      if (page == pageLen - 1) {
                        if (receipt == null) {
                          openSnackbarFailure(context, 'attach_receipt'.tr());
                          return;
                        }
                        _handleSend();
                      } else {
                        pageController.nextPage(
                            duration: duration, curve: curve);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  final pageLen = 2;
  final duration = const Duration(milliseconds: 200);
  final curve = Curves.easeInOut;
}
