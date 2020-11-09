import 'package:bee_log/home.dart';
import 'package:bee_log/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'emailAuthentication.dart';
import 'main.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _email;
  String _password;
  Auth _authenticator;
  var _passcont = TextEditingController();
  var _emailcont = TextEditingController();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _authenticator = new Auth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _emailcont,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextField(
              controller: _passcont,
              obscureText: _obscureText,
              decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                      icon: Icon(FontAwesomeIcons.eye), onPressed: _toggle)),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            RaisedButton(
              onPressed: () {
                _authenticator.signUp(_email, _password);
                _passcont.clear();
                _emailcont.clear();
              },
              // onPressed: () {
              //   FirebaseAuth.instance
              //       .createUserWithEmailAndPassword(
              //           email: email, password: password)
              //       .then((signedInUser) {
              //     firestore.collection("users").add(
              //         {"email": email, "password": password}).then((value) {
              //       if (signedInUser != null) {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) => HomePage()));
              //         passcont.clear();
              //         emailcont.clear();
              //       }
              //     }).catchError((e) {
              //       print(e);
              //     });
              //   }).catchError((e) {
              //     print(e);
              //   });
              // },
              child: Text("SignUp"),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text("Already Have an Account ?"),
            )
          ],
        ),
      ),
    );
  }
}

showAlertDialog(String e) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(e),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: navigatorKey.currentContext,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
