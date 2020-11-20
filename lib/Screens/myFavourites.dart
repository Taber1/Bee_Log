import 'package:flutter/material.dart';

class myFavourites extends StatefulWidget {
  @override
  _myFavouritesState createState() => _myFavouritesState();
}

class _myFavouritesState extends State<myFavourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
      ),
      body: Center(
        child: Text("MY FAVOURITES"),
      ),
    );
  }
}
