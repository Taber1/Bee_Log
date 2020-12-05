import 'package:bee_log/Screens/myFavourites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Auth/login.dart';

class Draw_Wer extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final fbLogin = FacebookLogin();
  String imgUrl;
  String name;
  String email;
  Draw_Wer(this.imgUrl, this.name, this.email);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.orange),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: name.contains("@")
                      ? AssetImage('assets/images/user.png')
                      : NetworkImage(imgUrl),
                  radius: 35,
                ),
                SizedBox(height: 10),
                Text(
                  name.contains("@") ? name.split("@")[0].toUpperCase() : name,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  email,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'My Profiles',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.arrow_right,
              size: 30,
            ),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => myProfiles()));
            },
          ),
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 0.3,
          ),
          ListTile(
            title: Text(
              'My Favourites',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.arrow_right,
              size: 30,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => myFavourites()));
            },
          ),
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 0.3,
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.logout,
              size: 30,
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              await fbLogin.logOut();
              await googleSignIn.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 0.3,
          ),
        ],
      ),
    );
  }
}
