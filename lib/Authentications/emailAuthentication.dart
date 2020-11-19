import 'dart:async';
import 'package:bee_log/main.dart';
import 'package:bee_log/Screens/SplashForSignup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Screens/home.dart';
import 'package:bee_log/Widgets/AlertDialog.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final BuildContext context;
  Auth(this.context);

  Future<String> signUp(String email, String password) async {
    try {
      User user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      await user.sendEmailVerification();
      Navigator.push(navigatorKey.currentContext,
          MaterialPageRoute(builder: (context) => Splash(email, password)));
      // ? {
      //     Get.to(HomePage()),
      //     _firestore
      //         .collection("users")
      //         .add({"email": email, "password": password})
      //   }
      // : Get.to(Splash());

    } on PlatformException catch (e) {
      return showAlertDialog(context, e.message);
    } catch (e) {
      return showAlertDialog(context, e);
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user.emailVerified) {
        Navigator.push(
            navigatorKey.currentContext,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage("", email.toUpperCase(), email)));
        // return user.uid;
      }
    } catch (e) {
      return showAlertDialog(context, e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return showAlertDialog(context, e);
    }
  }
}
