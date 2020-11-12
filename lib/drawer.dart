import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Draw_Wer extends StatelessWidget {
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
              'Logout',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.logout,
              size: 30,
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
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
