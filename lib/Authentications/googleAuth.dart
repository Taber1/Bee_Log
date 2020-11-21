import 'package:bee_log/Screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bee_log/Widgets/AlertDialog.dart';

import '../main.dart';

class GoogleAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BuildContext context;
  GoogleAuth(this.context);

  String name;
  String email;
  String imageUrl;

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final User user = (await _auth.signInWithCredential(credential)).user;

      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;

      final User currentUser = await _auth.currentUser;
      assert(user.uid == currentUser.uid);

      _firestore.collection("users").doc("GoogleAuth").collection("gAuth").add(
          {"email": email, "name": name, "image": imageUrl}).catchError((e) {
        print(e);
      });

      return Navigator.push(
          navigatorKey.currentContext,
          MaterialPageRoute(
              builder: (context) => HomePage(imageUrl, name, email)));
    } on PlatformException catch (e) {
      return showAlertDialog(context, e);
    } catch (e) {
      showAlertDialog(context, e);
      return e;
    }
  }
}
