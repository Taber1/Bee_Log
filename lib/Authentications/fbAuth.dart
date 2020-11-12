import 'package:bee_log/Authentications/emailAuthentication.dart';
import 'package:bee_log/Screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../main.dart';

class FbAuth {
  final fbLogin = FacebookLogin();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BuildContext context;
  FbAuth(this.context);

  String email;
  String public_profile;

  Future<String> signInFacebook() async {
    try {
      FacebookLogin facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email', 'public_profile']);
      FacebookAccessToken facebookAccessToken = result.accessToken;
      AuthCredential authCredential =
          FacebookAuthProvider.credential(facebookAccessToken.token);
      User user =
          (await _firebaseAuth.signInWithCredential(authCredential)).user;

      assert(user.email != null);
      assert(user.displayName != null);

      public_profile = user.displayName;
      email = user.email;

      final User currentUser = await _firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);

      _firestore
          .collection("users")
          .doc("FacebookAuth")
          .collection("fAuth")
          .add({"email": email, "public_profile": public_profile}).catchError(
              (e) {
        print(e);
      });

      return Navigator.push(
          navigatorKey.currentContext,
          MaterialPageRoute(
              builder: (context) => HomePage("", public_profile, email)));
    } on PlatformException catch (e) {
      showAlertDialog(context, e);
    } catch (e) {
      return showAlertDialog(context, e);
    }
  }
}
