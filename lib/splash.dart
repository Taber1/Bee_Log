import 'dart:async';
import 'package:bee_log/home.dart';
import 'package:bee_log/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  String em;
  String ps;
  Splash(this.em, this.ps);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isUserEmailVerified;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
        await FirebaseAuth.instance.currentUser
          ..reload();
        var user = await FirebaseAuth.instance.currentUser;
        if (user.emailVerified) {
          setState(() {
            _isUserEmailVerified = user.emailVerified;
            _firestore
                .collection('users')
                .doc("EmailAuth")
                .collection("eAuth")
                .add({"email": widget.em, "password": widget.ps});
          });
          timer.cancel();
          Navigator.push(navigatorKey.currentContext,
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Container(
                  height: 50,
                  width: 50,
                  child: Image.network(
                      "https://acegif.com/wp-content/uploads/loading-22.gif")))
        ],
      ),
    );
  }
}
