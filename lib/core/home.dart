import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/mixins/search_mixin.dart';
import 'package:talimger_mobile/screens/home/home_view.dart';
import 'package:talimger_mobile/services/notification_service.dart';

import '../providers/user_data_provider.dart';
import '../utils/disable_user_dialog.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  _initData() async {
    SearchMixin.getRecentSearchList(ref: ref);
    await NotificationService().initFirebasePushNotification(context, ref).then(
          (value) => NotificationService().checkNotificationSubscription(ref),
        );
  }

  _checkUserAccess() async {
    final bool isDisabled = ref.read(userDataProvider)?.isDisbaled ?? false;
    if (isDisabled) {
      await Future.delayed(const Duration(seconds: 3))
          .then((value) => openDisableUserDialog(context));
    }
  }

  @override
  void initState() {
    _initData();
    _checkUserAccess();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}
