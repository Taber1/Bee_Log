import 'package:bee_log/drawer.dart';
import 'package:bee_log/login.dart';
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
        actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      body: Center(
        child: Text("HOME"),
      ),
      drawer: Draw_Wer(widget.imgUrl, widget.name, widget.email),
    );
  }
}
