import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../components/user_avatar.dart';
import '../../../mixins/user_mixin.dart';
import '../../../models/user_model.dart';

class UserInfo extends StatelessWidget with UserMixin {
  const UserInfo({super.key, required this.user, required this.ref});

  final UserModel user;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserAvatar(imageUrl: user.imageUrl, radius: 100, iconSize: 50),
        const SizedBox(height: 20),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          user.email,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
