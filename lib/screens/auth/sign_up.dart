import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talimger_mobile/providers/user_data_provider.dart';
import 'package:talimger_mobile/screens/auth/confirm_email.dart';
import 'package:line_icons/line_icons.dart';
import 'package:talimger_mobile/components/privacy_info.dart';
import 'package:talimger_mobile/models/user_model.dart';
import 'package:talimger_mobile/screens/auth/login.dart';
import 'package:talimger_mobile/services/auth_service.dart';
import 'package:talimger_mobile/services/firebase_service.dart';
import 'package:talimger_mobile/utils/next_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key, this.popUpScreen});

  final bool? popUpScreen;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  var nameCtlr = TextEditingController();
  var emailCtlr = TextEditingController();
  var passwordCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();

  final _btnController = RoundedLoadingButtonController();

  bool offsecureText = true;
  IconData lockIcon = LineIcons.lock;

  UserModel _userModel(UserCredential userCredential) {
    final UserModel user = UserModel(
      id: userCredential.user!.uid,
      email: userCredential.user!.email ?? emailCtlr.text,
      name: userCredential.user!.displayName ?? nameCtlr.text,
      createdAt: DateTime.now().toUtc(),
      phoneNum: phoneCtrl.text.isEmpty ? null : phoneCtrl.text,
      imageUrl: userCredential.user?.photoURL,
      platform: Platform.isAndroid ? 'Android' : 'iOS',
    );
    return user;
  }

  Future _handleSignUpWithUsernamePassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _btnController.start();
      final UserCredential? userCredential = await AuthService()
          .signUpWithEmailPassword(
              context, emailCtlr.text.trim(), passwordCtrl.text.trim())
          .onError((error, stackTrace) {
        _btnController.reset();
        return null;
      });
      if (userCredential != null && userCredential.user != null) {
        await FirebaseService().saveUserData(_userModel(userCredential));
        await FirebaseService().updateUserStats();
        _btnController.success();
        await AuthService().sendEmailVerification();
        afterSignIn();
      } else {
        _btnController.reset();
      }
    }
  }

  void _onlockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LineIcons.lockOpen;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LineIcons.lock;
      });
    }
  }

  void afterSignIn() async {
    await ref.read(userDataProvider.notifier).getData();
    Navigator.pop(context);
    NextScreen.openBottomSheet(context, const ConfirmEmailScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 50),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'create-account',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 28),
              ).tr(),
              const SizedBox(
                height: 5,
              ),
              Text(
                'follow-simple-steps',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ).tr(),
              // SocialLogins(
              //   afterSignIn: afterSignIn,
              // ),
              // Container(
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.symmetric(vertical: 20),
              //   child: const Text(
              //     '------ OR ------',
              //     style: TextStyle(color: Colors.blueGrey),
              //   ),
              // ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        hintText: 'enter-name'.tr(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3)),
                        label: const Text('name').tr(),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 20,
                          ),
                          onPressed: () => nameCtlr.clear(),
                        )),
                    controller: nameCtlr,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) return 'name_required'.tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        hintText: 'enter-email'.tr(),
                        label: const Text('email').tr(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3)),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 20,
                          ),
                          onPressed: () => emailCtlr.clear(),
                        )),
                    controller: emailCtlr,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'email_required'.tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        hintText: 'enter-phone'.tr(),
                        label: const Text('phone').tr(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3)),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 20,
                          ),
                          onPressed: () => phoneCtrl.clear(),
                        )),
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        hintText: 'enter-password'.tr(),
                        label: const Text('password').tr(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3)),
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.all(0),
                          style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(0)),
                          icon: Icon(
                            lockIcon,
                            size: 20,
                          ),
                          onPressed: () => _onlockPressed(),
                        )),
                    controller: passwordCtrl,
                    obscureText: offsecureText,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty) return 'password_required'.tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  RoundedLoadingButton(
                    animateOnTap: false,
                    controller: _btnController,
                    onPressed: () => _handleSignUpWithUsernamePassword(),
                    width: MediaQuery.of(context).size.width * 1.0,
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    child: Text(
                      'create-account',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ).tr(),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 15),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "already-have-account",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ).tr(),
                        TextButton(
                            child: Text(
                              'login',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                            ).tr(),
                            onPressed: () => NextScreen.replace(
                                context, const LoginScreen())),
                      ],
                    ),
                  ),
                  const PrivacyInfo(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
