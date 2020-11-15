import 'package:bee_log/Screens/addPost.dart';
import 'package:bee_log/Screens/drawer.dart';
import 'package:bee_log/Screens/login.dart';
import 'package:bee_log/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String name;
  String email;
  String imgUrl;
  HomePage(this.imgUrl, this.name, this.email);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(navigatorKey.currentContext,
                    MaterialPageRoute(builder: (context) => AddPost()));
              })
        ],
      ),
      body: Center(
        child: Text("HOME"),
      ),
      drawer: Draw_Wer(widget.imgUrl, widget.name, widget.email),
    );
  }
}
