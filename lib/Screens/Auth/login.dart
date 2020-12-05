import 'package:bee_log/Authentications/fbAuth.dart';
import 'package:bee_log/Authentications/googleAuth.dart';
import 'package:bee_log/Screens/home.dart';
import 'package:bee_log/Screens/Auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Authentications/emailAuthentication.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  var _emailcont = TextEditingController();
  var _passcont = TextEditingController();
  Auth _authenticator;
  GoogleAuth _gauth;
  FbAuth _fbauth;
  String _email;
  String _password;
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _authenticator = new Auth(context);
    _gauth = new GoogleAuth(context);
    _fbauth = new FbAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                // _authenticator.signIn(_email, _password);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage("imgUrl", "name@", "email")));
                _passcont.clear();
                _emailcont.clear();
              },
              // onPressed: () {
              //   _auth
              //       .signInWithEmailAndPassword(
              //           email: email, password: password)
              //       .then((values) {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => HomePage()));
              //     _emailcont.clear();
              //     _passcont.clear();
              //   }).catchError((e) {
              //     print(e);
              //   });
              // },
              child: Text("Sign In"),
            ),
            GoogleSignInButton(
              onPressed: () {
                _gauth.signInWithGoogle();
              },
            ),
            FacebookSignInButton(
              onPressed: () {
                _fbauth.signInFacebook();
              },
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text("Create an Account"),
            ),
            InkWell(
              onTap: () {
                _authenticator.resetPassword(_email);
                _emailcont.clear();
              },
              child: Text("Forget Password"),
            )
          ],
        ),
      ),
    );
  }
}
