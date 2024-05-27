import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talimger_mobile/services/firebase_exceptions.dart';
import 'package:talimger_mobile/utils/snackbars.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> userSteam = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<UserCredential?> loginWithEmailPassword(
      BuildContext context, String email, String password) async {
    UserCredential? user;
    try {
      user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final String msg = getTranlsatedFirebaseError(e.code);
      if (!context.mounted) return null;

      openSnackbarFailure(context, msg);
    }
    return user;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future userLogOut() async {
    if (user != null) {
      await _firebaseAuth.signOut();
    } else {
      debugPrint('Вы не аутентифицированы');
    }
  }

  Future<UserCredential?> signUpWithEmailPassword(
      BuildContext context, String email, String password) async {
    UserCredential? user;
    try {
      user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('error: e');
      if (!context.mounted) return null;
      final String msg = getTranlsatedFirebaseError(e.code);

      openSnackbarFailure(context, msg);
    }
    return user;
  }

  Future deleteUserAuth() async {
    await user?.delete().catchError((e) {
      debugPrint('error on deleting account');
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  Future sendEmailVerification() async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.currentUser!
          .sendEmailVerification()
          .catchError((e) => debugPrint('Ошибка при отправке сообщения'));
    }
  }

  Future sendPasswordRestEmail(BuildContext context, String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      openSnackbar(context, 'reset_password_sent'.tr());
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) return;
      final String msg = getTranlsatedFirebaseError(error.code);

      openSnackbarFailure(context, msg);
    }
  }

  Future<bool> isConfirmed(BuildContext context) async {
    if (_firebaseAuth.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.reload();
      return _firebaseAuth.currentUser!.emailVerified;
    } else {
      return false;
    }
  }
}
