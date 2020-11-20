import 'package:flutter/material.dart';

class FavScreen extends StatefulWidget {
  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: null,
      itemBuilder: (context, index) {
        return ListTile();
      },
    );
  }
}
