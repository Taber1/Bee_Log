import 'package:bee_log/Models/posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart';

import 'PostScreen.dart';

class myFavourites extends StatefulWidget {
  @override
  _myFavouritesState createState() => _myFavouritesState();
}

class _myFavouritesState extends State<myFavourites> {
  List<Posts> favPost = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<Null> favListRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postRef.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var Data = snapshot.value;
      favPost.clear();

      for (var individualKey in KEYS) {
        if (Data[individualKey]['Fav'] == true) {
          Posts posts = Posts(
              Data[individualKey]["date"],
              Data[individualKey]["description"],
              Data[individualKey]["image"],
              Data[individualKey]["time"],
              Data[individualKey]["title"],
              Data[individualKey]["key"],
              Data[individualKey]['Fav']);

          favPost.add(posts);
        }
        setState(() {
          // print('length:${listPost.length}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favourites"),
        ),
        body: FutureBuilder(
          future: favListRefresh(),
          builder: (context, snapshot) {
            return StaggeredGridView.countBuilder(
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(2, index.isEven ? 2 : 3),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              crossAxisCount: 4,
              itemCount: favPost.length,
              itemBuilder: (BuildContext context, int index) {
                return eachFavPost(
                    favPost[index].date,
                    favPost[index].description,
                    favPost[index].image,
                    favPost[index].time,
                    favPost[index].title,
                    favPost[index].id,
                    favPost[index].fav);
              },
            );
          },
        ));
  }
}

class eachFavPost extends StatefulWidget {
  String date;
  String description;
  String image;
  String time;
  String title;
  String id;
  bool fav;
  eachFavPost(this.date, this.description, this.image, this.time, this.title,
      this.id, this.fav);

  @override
  _eachFavPostState createState() => _eachFavPostState();
}

class _eachFavPostState extends State<eachFavPost> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostScreen(widget.image, widget.title,
                  widget.description, widget.date, widget.time))),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              widget.image,
              fit: BoxFit.fitHeight,
            ),
            Text(widget.title)
          ],
        ),
      ),
    );
  }
}
